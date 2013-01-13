class Expense < ActiveRecord::Base
  attr_accessible :paid_in, :household_id, :split_evenly, :roommate_id, :value, :settled, :note, :item_name
  belongs_to :household
  belongs_to :roommate
  has_many :roommate_expenses

  scope :split, where(:split => true)
  scope :not_split, where(:split => false)

  before_validation :default_values

  def default_values
    self.split_evenly = true if self.split_evenly.nil?
    true
  end

  def cost_to roommate
    paid_in = self.roommate == roommate ? self.paid_in : !self.paid_in
    value = self.split_evenly? ? self.value / self.roommate_expenses.included.count : self.value
    paid_in ? 0 - value : value
  end

  def impact
    paid_in ? value : 0 - value
  end

  validates_presence_of :household_id, :roommate_id, :value, :item_name
end
