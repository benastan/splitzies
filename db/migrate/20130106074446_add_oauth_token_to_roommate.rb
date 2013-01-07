class AddOauthTokenToRoommate < ActiveRecord::Migration
  def change
    add_column :roommates, :oauth_token, :string
  end
end
