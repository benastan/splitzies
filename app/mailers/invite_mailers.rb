class InviteMailers < ActionMailer::Base
  default from: "Splitzies Invitations <team@benbergstein.mailgun.org>"

  def first_notification invite
    @invite = invite
    @roommate = invite.roommate
    if @invite.email
      mail(to: @invite.email, subject: "#{@invite.roommate.full_name} Wants To Share Expenses With You", :reply_to => "#{@invite.roommate.full_name} <#{@invite.email}>")
    end
  end
end
