# 03-vote

## how to deploy
(dedicated for lumbermill's environment)

```
git archive main > tmp/archive.tar
scp tmp/archive.tar sakura31:/var/www/vote/
ssh sakura31 "cd /var/www/vote && tar xf archive.tar -C current"
```

```
cd /var/www/vote/current
bundle install
rails assets:precompile
rails db:prepare
```

```
sudo systemctl restart puma-vote
sudo systemctl reload apache2
```