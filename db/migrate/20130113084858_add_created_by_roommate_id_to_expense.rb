class AddCreatedByRoommateIdToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :created_by_roommate_id, :integer
  end
end
