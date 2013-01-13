class RoommateNotification < ActiveRecord::Base
  attr_accessible :notification_id, :roommate_id, :seen_at
  belongs_to :notification
  belongs_to :roommate

  default_scope where(seen_at: nil)

  def seen!
    self.update_attribute seen_at, Time.new
  end

  def seen?
    ! seen_at.nil?
  end
end
