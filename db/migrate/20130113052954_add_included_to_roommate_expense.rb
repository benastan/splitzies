class AddIncludedToRoommateExpense < ActiveRecord::Migration
  def change
    add_column :roommate_expenses, :included, :boolean, default: true
  end
end
