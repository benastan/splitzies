class CreateRoommates < ActiveRecord::Migration
  def change
    create_table :roommates do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :fb_id
      t.integer :household_id

      t.timestamps
    end
  end
end
