class AddItemNameToExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :item_name, :string
  end
end
