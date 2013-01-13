class Roommate < ActiveRecord::Base
  attr_accessible :email, :fb_id, :first_name, :household_id, :last_name, :oauth_token, :oauth_expiration
  validates_uniqueness_of :email, :fb_id
  belongs_to :household
  has_many :expenses
  has_many :roommate_expenses

  state_machine :state, initial: :create_household do
    state :active do
      validates_presence_of :household_id
    end

    event :next_step do
      transition :create_household => :invite_roommates, :invite_roommates => :active
    end
  end

  def photo size = :square
    "http://graph.facebook.com/#{fb_id}/picture?size=#{size}"
  end

  def expenses_share
    split = household.expenses.split
    not_split = household.expenses.not_split
    roommate_split = self.expenses
  end

  def full_name
    "#{first_name} #{last_name}"
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

  def create_household
    state == 'create_household'
  end
end
