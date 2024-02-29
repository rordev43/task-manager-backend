class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :due_date, null: false
      t.datetime :completed_date
      t.string :status, null: false, default: "Pending"
      t.integer :progress, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
