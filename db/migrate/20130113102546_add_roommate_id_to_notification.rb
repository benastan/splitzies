class AddRoommateIdToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :roommate_id, :integer
  end
end
