class Expense < ActiveRecord::Base
  acts_as_paranoid

  attr_accessible :paid_in, :household_id, :split_evenly, :roommate_id, :value, :settled, :note, :item_name, :created_by_roommate_id
  belongs_to :household
  belongs_to :roommate
  belongs_to :created_by_roommate, :class_name => :Roommate
  has_many :roommates, through: :household
  has_many :roommate_expenses
  has_many :notifications, as: :axis

  scope :split, where(:split => true)
  scope :not_split, where(:split => false)

  before_validation :default_values

  def included_roommates
    roommate_expenses.included.collect { |re| re.roommate }
  end

  def default_values
    self.split_evenly = true if self.split_evenly.nil?
    true
  end

  def cost_to current_roommate
    if included_roommates.include? current_roommate
      paid_in = self.roommate == current_roommate ? self.paid_in : !self.paid_in
      paid_in ? split_cost - value : split_cost
    else
      0
    end
  end

  def split_cost
    split_evenly? ? value / roommate_expenses.included.count : value
  end

  def impact
    paid_in ? value : 0 - value
  end

  validates_presence_of :household_id, :roommate_id, :value, :item_name
end
