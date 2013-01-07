class Household < ActiveRecord::Base
  attr_accessible :nickname

  has_many :roommates
  has_many :expenses
end
