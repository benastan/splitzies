class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :roommate_id
      t.string :fb_id
      t.boolean :open

      t.timestamps
    end
  end
end
