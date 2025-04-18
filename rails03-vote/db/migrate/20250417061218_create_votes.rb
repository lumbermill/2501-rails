class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.integer :event_id, null: false
      t.string :name, null: false, default: ""
      t.string :answers, null: false, default: ""
      t.string :comment, null: false, default: ""

      t.timestamps
    end
  end
end
