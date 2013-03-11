class AddImageUrlToRoommate < ActiveRecord::Migration
  def change
    add_column :roommates, :image_url, :string
  end
end
