# TODO

## rails05-papertrail

データベースレコードのリビジョン管理をpaper_trailなど外部の仕組みに頼らず実現したい。
誰が、いつ、という部分が最も大事だが、できれば、添付ファイルの履歴も残したいし、バージョン間の差異も抽出できるようにしたい。

### 目的

データベースレコードのリビジョン管理を paper_trail などの外部 gem に頼らず、
Rails の標準機能（ActiveRecord callbacks + JSON）だけで実現する。

**要件の優先順位**
1. 誰が・いつ変更したかを記録する（whodunnit + created_at）
2. 添付ファイルの変更履歴を残す（Active Storage のメタデータを versions に保存）
3. バージョン間の差分を抽出できる（JSON レベルの diff）

---

### 手順

#### Step 1: サンプルモデルの用意

```sh
rails g model Article title:string body:text published:boolean
rails active_storage:install
```

Article に `has_one_attached :attachment` を追加。

#### Step 2: versions テーブルの作成

```sh
rails g model Version \
  item_type:string item_id:bigint \
  event:string whodunnit:string \
  object:text object_changes:text
```

- `object` — 変更前のレコードを JSON で保存
- `object_changes` — 変更されたカラムとその前後の値を JSON で保存
- `item_type / item_id` にポリモーフィックインデックスを追加

#### Step 3: Current attributes で編集者を追跡

`app/models/current.rb` に `attribute :user` を追加。
ApplicationController で `Current.user = current_user` をセット。

#### Step 4: Versionable コンサーンの実装

`app/models/concerns/versionable.rb` を新規作成。

```ruby
module Versionable
  extend ActiveSupport::Concern
  included do
    has_many :versions, as: :item, class_name: "Version", dependent: :destroy
    after_create  :record_create
    after_update  :record_update
    before_destroy :record_destroy
  end

  def reify(version)
    # version.object の JSON でインスタンスを復元
  end

  def diff(v1, v2)
    # object_changes の JSON を比較して差分ハッシュを返す
  end
end
```

Article に `include Versionable` を追加。

#### Step 5: 添付ファイル履歴

- `record_update` コールバック内で `attachment.blob.attributes` を `object_changes` に含める
- Active Storage のバージョン情報（filename, byte_size, checksum）を JSON に追記

#### Step 6: 差分 UI

- `articles/:id/versions` ルートと `VersionsController#index` を実装
- 各バージョンのフィールド差分を表形式で表示（変更前 → 変更後）

---

### 確認方法

```ruby
bin/rails console

a = Article.create!(title: "v1", body: "hello")
a.update!(title: "v2")
a.versions.count   # => 2
a.diff(a.versions.first, a.versions.last)
# => { "title" => ["v1", "v2"] }
a.reify(a.versions.first).title  # => "v1"
```

---

## rails06-deploy

Rails標準のデプロイ機能を試す。

### 目的

Rails 8 に同梱されている Kamal を使って、実際にアプリを VPS へデプロイする。
Capistrano 等の旧来ツールを使わず、Rails 標準の手順だけで本番公開の流れを体験する。

---

### 前提条件の準備（作業前に確認）

- [ ] デプロイ先サーバー（さくら VPS / Hetzner / DigitalOcean 等）の SSH アクセス
- [ ] GitHub アカウント（GHCR を使うため）
- [ ] GitHub Personal Access Token（スコープ: `write:packages`）
- [ ] ドメインまたはサーバーの IP アドレス

---

### 手順

#### Step 1: Kamal gem の追加

rails06-deploy の Gemfile に kamal が含まれていないため追加。

```sh
bundle add kamal
kamal init   # config/deploy.yml と Dockerfile が生成される
```

#### Step 2: Dockerfile の確認

Rails 8 が自動生成する Dockerfile をそのまま使う。
`RAILS_ENV=production` で動くことをローカルで確認：

```sh
docker build -t rails06-deploy .
```

#### Step 3: config/deploy.yml の設定

```yaml
service: rails06-deploy
image: ghcr.io/<github-username>/rails06-deploy

servers:
  web:
    - <server-ip>

registry:
  server: ghcr.io
  username: <github-username>
  password:
    - KAMAL_REGISTRY_PASSWORD   # GitHub PAT (write:packages)

env:
  secret:
    - RAILS_MASTER_KEY
```

#### Step 4: 環境変数の設定

`.env` に以下を記載（`.gitignore` 済みであることを確認）：

```
KAMAL_REGISTRY_PASSWORD=<github-pat-with-write-packages>
RAILS_MASTER_KEY=<config/master.key の値>
```

```sh
kamal env push   # .env をサーバーに転送
```

#### Step 5: デプロイ実行

```sh
kamal setup    # 初回: Docker インストール + Traefik 起動
kamal deploy   # イメージビルド → push → サーバー上でコンテナ入れ替え
```

#### Step 6: 動作確認

```sh
kamal app logs                       # アプリのログ
kamal app exec "rails db:migrate"    # マイグレーション実行
```

ブラウザから `http://<server-ip>` にアクセスして Rails のデフォルト画面が表示されれば完了。

---

### 確認方法（ロールバック含む）

```sh
kamal rollback <version>   # 直前バージョンに戻す
kamal details              # コンテナ状態を確認
```
