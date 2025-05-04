class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false, default: ""
      t.string :description, null: false, default: ""
      t.string :schedules, null: false, default: "", comment: "Comma-separated list of schedules"
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
