class InformNotificationRecipient
  @queue = :notifications

  def self.perform roommate_notification_id
    @roommate_notification = RoommateNotification.find(roommate_notification_id)
    NotificationMailers.roommate_notification_notification(@roommate_notification).deliver
  end
end
