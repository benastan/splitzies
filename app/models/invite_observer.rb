class InviteObserver < ActiveRecord::Observer
  def after_save invite
    unless invite.open
      facebook = Koala::Facebook::API.new invite.invitee.oauth_token
      requests = facebook.get_connections 'me', 'apprequests'
      facebook.batch do |batch_api|
        requests.each do |req|
          batch_api.delete_object req['id']
        end
      end
    end
  end
end
