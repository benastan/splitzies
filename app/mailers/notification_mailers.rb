class NotificationMailers < ActionMailer::Base
  default from: "Splitzies.com <team@benbergstein.mailgun.org>"

  def notifications_digest user
    @user = user
    @roommate_notifications = @user.roommate_notifications
    mail(from: "#{@user.household.nickname} Expenses (Splitzies.com) <team@benbergstein.mailgun.org>", to: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: "Expense Update")
  end
end
