class AddShaToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :sha, :string
  end
end
