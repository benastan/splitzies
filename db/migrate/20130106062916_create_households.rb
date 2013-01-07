class CreateHouseholds < ActiveRecord::Migration
  def change
    create_table :households do |t|
      t.string :nickname

      t.timestamps
    end
  end
end
