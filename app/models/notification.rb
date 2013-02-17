class Notification < ActiveRecord::Base
  attr_accessible :action, :axis_id, :axis_type, :roommate_id

  belongs_to :roommate
  belongs_to :axis, polymorphic: true
  has_many :roommate_notifications

  def axis
    Kernel.const_get(axis_type).unscoped do
      super
    end
  end

  def roommate? r
    roommate == r
  end

  def seen_by? roommate
    @seen_by ||= roommate_notifications.where(roommate_id: roommate.id).seen?
  end

  def notify! roommate
    if roommate.is_a?(Array)
      roommate.collect do |r|
        self.notify!(r)
      end
    else
      roommate_notifications.create(
        roommate_id: roommate.id
      )
    end
  end

  def self.notify! recipients, roommate, action, axis
    @notification = Notification.new(
      action: action,
      roommate_id: roommate.id
    )
    @notification.axis = axis

    if @notification.save
      @notification.notify!(recipients).each do |roommate_notification|
        puts 'sakldjglskajglkasjdglkjasg'
        if roommate_notification.roommate.immediately_notify?
          puts 'Sending notification'
          puts Resque.enqueue(InformNotificationRecipient, roommate_notification.id)
        end
      end
    end
    @notification
  end
end
