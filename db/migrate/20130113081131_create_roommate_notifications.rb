class CreateRoommateNotifications < ActiveRecord::Migration
  def change
    create_table :roommate_notifications do |t|
      t.integer :roommate_id
      t.integer :notification_id
      t.time :seen_at

      t.timestamps
    end
  end
end
