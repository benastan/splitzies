class RoommateExpense < ActiveRecord::Base
  attr_accessible :expense_id, :roommate_id, :included

  scope :split, where('expenses.split_evenly = TRUE')
  scope :included, where(included: true)
  scope :exempt, where(included: false)

  belongs_to :expense
  belongs_to :roommate
  after_initialize :set_defaults

  private

  def set_defaults
    self.included = true if included.nil?
  end
end
