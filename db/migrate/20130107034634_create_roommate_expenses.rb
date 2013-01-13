class CreateRoommateExpenses < ActiveRecord::Migration
  def change
    create_table :roommate_expenses do |t|
      t.integer :expense_id
      t.integer :roommate_id

      t.timestamps
    end
  end
end
