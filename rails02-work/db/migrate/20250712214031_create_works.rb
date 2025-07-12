class CreateWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :works do |t|
      t.integer :user_id
      t.date :work_on
      t.datetime :start_at
      t.datetime :end_at
      t.string :location
      t.text :body
      t.boolean :approved

      t.timestamps
    end
  end
end
