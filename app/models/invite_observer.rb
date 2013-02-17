class InviteObserver < ActiveRecord::Observer
  def after_save invite
    unless invite.open
      if invite.fb?
        Notification.notify! invite.roommate, invite.invitee, :accepted, invite

        facebook = Koala::Facebook::API.new invite.invitee.oauth_token
        requests = facebook.get_connections 'me', 'apprequests'
        facebook.batch do |batch_api|
          requests.each do |req|
            batch_api.delete_object req['id']
            invite = Invite.find_by_request_id req['id']
            invite.update_attribute :open, false if invite.open
          end
        end
      else
        invites = Invite.where(email: invite.email, open: true)
        invites.each do |i|
          i.update_attribute(:open, false)
        end
      end
    end
  end
end
