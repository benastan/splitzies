class SendNotificationsDigestToAllUsers
  @queue = :notifications

  def self.perform
    puts 'Sending notifications digest'

    Roommate.all.each do |roommate|
      puts should_notify? roommate
      if should_notify?(roommate)
        puts "Sending notification mailer to #{roommate.first_name}."
        roommate.update_attribute(:last_notified, Time.now)
        NotificationMailers.notifications_digest(roommate).deliver
      end
    end
  end

  private

  def self.should_notify? roommate
    ! roommate.notifications.empty? && (roommate.last_notified.nil? || (roommate.notify_every && roommate.notify_every < Time.now - roommate.last_notified))
  end
end
