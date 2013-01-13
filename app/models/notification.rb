class Notification < ActiveRecord::Base
  attr_accessible :action, :axis_id, :axis_type, :roommate_id

  belongs_to :roommate
  belongs_to :axis, polymorphic: true
  has_many :roommate_notifications

  def seen_by? roommate
    @seen_by ||= roommate_notifications.where(roommate_id: roommate.id).seen?
  end

  def notify! roommate
    if roommate.is_a? Array
      roommate.each do |r|
        self.notify! r
      end
    else
      self.roommate_notifications.create(
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
    @notification.save
    @notification.notify! recipients
    @notification
  end
end
