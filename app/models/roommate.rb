class Roommate < ActiveRecord::Base

  has_secure_password

  ##############
  # ATTRIBUTES #
  ##############

  attr_accessible :email, :fb_id, :first_name, :household_id, :last_name, :oauth_token, :oauth_expiration, :password, :password_confirmation, :notify_every, :immediately_notify, :image_url
  delegate :roommates, to: :household
  store :preferences, accessors: [ :notify_every, :last_notified, :immediately_notify ]

  #################
  # RELATIONSHIPS #
  #################

  belongs_to :household
  has_many :expenses
  has_many :roommate_expenses
  has_many :roommate_notifications
  has_many :notifications, through: :roommate_notifications

  ##############
  # VALIDATION #
  ##############

  with_options if: :fb? do |r|
    r.validates_uniqueness_of :fb_id
  end

  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name, :email

  before_create :default_values

  JSON_DEFAULTS = {
    except: [ :oauth_token ]
  }

  def fb?
    ! fb_id.nil?
  end

  def as_json options = {}
    super(JSON_DEFAULTS.merge(options))
  end

  def household= household
    household.expenses.each do |e|
      e.roommate_expenses.create(
        roommate_id: id,
        included: false
      )
    end
  end

  state_machine :state, initial: :create_household do
    state :active do
      validates_presence_of :household_id
    end

    event :next_step do
      transition :create_household => :invite_roommates, :invite_roommates => :active
    end
  end

  def photo size = :square
    if image_url
      image_url
    elsif fb_id
      "http://graph.facebook.com/#{fb_id}/picture?size=#{size}"
    else
      "http://www.tvscoop.tv/76495669.jpg"
    end
  end

  def expenses_share
    split = household.expenses.split
    not_split = household.expenses.not_split
    roommate_split = self.expenses
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def cash_spent
    expenses.empty? ? 0 : expenses.reject { |e| ! e.paid_in? }.collect(&:value).reduce { |a, b| a + b }
  end

  def cash_obligation
  end

  def cash_owed
    household.expenses.collect { |e| e.cost_to self }.reduce { |a, b| a + b }
  end

  def active?
    state == 'active'
  end

  def invite_roommates?
    state == 'invite_roommates'
  end

  def immediately_notify?
    immediately_notify != false
  end

  def create_household?
    state == 'create_household'
  end

  def default_values
    self.immediately_notify = true if immediately_notify.nil?
    self.notify_every = 1.day if notify_every.nil?
    true
  end
end
