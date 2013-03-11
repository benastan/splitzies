module ApplicationHelper
  def to_money dollas
    ((dollas.to_f * 100).ceil / 100.00)
  end
end
