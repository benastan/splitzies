class AddPasswordDigestToRoommate < ActiveRecord::Migration
  def change
    add_column :roommates, :password_digest, :string
  end
end
