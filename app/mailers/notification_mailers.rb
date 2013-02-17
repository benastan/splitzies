class NotificationMailers < ActionMailer::Base
  default from: "Splitzies.com <team@benbergstein.mailgun.org>"

  def notifications_digest user
    @user = user
    @roommate_notifications = @user.roommate_notifications
    mail(from: "#{@user.household.nickname} Expenses (Splitzies.com) <team@benbergstein.mailgun.org>", to: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: "Expense Update")
  end

  def roommate_notification_notification roommate_notification
    @roommate_notification = roommate_notification
    @user = roommate_notification.roommate
    mail(to: "#{@user.first_name} #{@user.last_name} <#{@user.email}>", subject: subject_line)
  end

  private

  def subject_line
    send(:"#{notification.axis_type.underscore}_subject_line", notification.axis)
  end

  def expense_subject_line expense
    "#{notification.roommate?(@user) ? 'You' : expense.roommate.first_name} #{notification.action} expense \"#{expense.item_name}\""
  end

  def invite_subject_line invite, notification
    "Your Splitzies Invite was #{notification.action}"
  end

  def notification
    @notification ||= @roommate_notification.notification
  end
end
