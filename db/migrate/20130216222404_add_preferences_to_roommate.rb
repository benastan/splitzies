class AddPreferencesToRoommate < ActiveRecord::Migration
  def change
    add_column :roommates, :preferences, :text
  end
end
