class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :household_id
      t.integer :roommate_id
      t.boolean :paid_in
      t.boolean :split_evenly
      t.decimal :value
      t.boolean :settled

      t.timestamps
    end
  end
end
