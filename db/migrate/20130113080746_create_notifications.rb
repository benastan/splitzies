class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :axis_id
      t.string :axis_type
      t.string :action

      t.timestamps
    end
  end
end
