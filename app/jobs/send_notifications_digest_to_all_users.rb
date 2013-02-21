class SendNotificationsDigestToAllUsers
  @queue = :notifications

  def self.perform
    puts 'Sending notifications digest'

    Roommate.all.each do |roommate|
      if should_notify?(roommate)
        puts "Sending notification mailer to #{roommate.first_name}."
        roommate.update_attribute(:last_notified, Time.now)
        NotificationMailers.notifications_digest(roommate).deliver
      else
        puts "Not sending notification mailer to #{roommate.first_name}."
      end
    end
  end

  private

  def self.should_notify? roommate
    if roommate.notify_every == 'false' || roommate.roommate_notifications.empty?
      return false
    end

    time_since_notified = Time.now - roommate.last_notified
    if roommate.last_notified.nil? || roommate.notify_every < time_since_notified
      return true
    end
  end
end
