class InviteeNotification
  @queue = :notifications

  def self.perform invite_id, type = :first_notification
    @invite = Invite.find(invite_id) rescue nil
    return unless @invite
    return if type != :first_notification && ! @invite.open
    InviteMailers.send(type, @invite).deliver
  end
end
