class AddOauthExpirationToRoommate < ActiveRecord::Migration
  def change
    add_column :roommates, :oauth_expiration, :date
  end
end
