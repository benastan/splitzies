class AddRequestIdToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :request_id, :string
  end
end
