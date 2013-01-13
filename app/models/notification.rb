class Notification < ActiveRecord::Base
  attr_accessible :action, :axis_id, :axis_type

  belongs_to :axis, polymorphic: true
  has_many :roommate_notifications

  def seen_by? roommate
    @seen_by ||= roommate_notifications.where(roommate_id: roommate.id).seen?
  end
end
