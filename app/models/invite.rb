class Invite < ActiveRecord::Base
  attr_accessible :request_id, :fb_id, :open, :roommate_id

  belongs_to :roommate

  validates_presence_of :fb_id, :request_id, :roommate_id

  before_validation :default_values


  private

  def default_values
    self.open = true if self.open.nil?
    true
  end
end
