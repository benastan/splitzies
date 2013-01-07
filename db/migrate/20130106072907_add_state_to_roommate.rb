class AddStateToRoommate < ActiveRecord::Migration
  def change
    add_column :roommates, :state, :string
  end
end
