class Invite < ActiveRecord::Base
  attr_accessible :request_id, :fb_id, :open, :roommate_id, :email, :sha

  belongs_to :roommate

  with_options :if => :fb? do |i|
    i.validates_presence_of :request_id
  end

  with_options :unless => :fb? do |i|
    i.validates_presence_of :email, :sha
    i.validate :email_unique_across_roommate
  end

  validates_presence_of :roommate_id

  before_validation :default_values
  before_validation :generate_sha!
  after_create :notify_invitee

  JSON_DEFAULTS = { :except => [ :sha ] }

  def to_json options = {}
    super(JSON_DEFAULTS.merge(options))
  end

  def serializable_hash options = {}
    super(JSON_DEFAULTS.merge(options))
  end

  def invitee
    @invitee ||= Roommate.find_by_fb_id fb_id rescue nil
  end

  def fb?
    ! fb_id.nil?
  end

  private

  def default_values
    self.open = true if self.open.nil?
    true
  end

  def notify_invitee
    return if email.nil?
    Resque.enqueue(InviteeNotification, id)
    Resque.enqueue_in(2.days, InviteeNotification, id, :reminder)
    Resque.enqueue_in(5.days, InviteeNotification, id, :final_reminder)
  end

  def generate_sha!
    return if email.nil?
    require 'digest/sha1'
    update_attribute(:sha, Digest::SHA1.hexdigest("#{Time.now.to_i}#{email}"))
  end

  def email_unique_across_roommate
    user = Roommate.find_by_email(email) rescue nil
    errors.add(:email, 'not unique') unless user.nil?
  end
end
