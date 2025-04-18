class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false, default: ""
      t.string :schedules, null: false, default: ""
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
