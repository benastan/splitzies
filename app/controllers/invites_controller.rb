class InvitesController < ApplicationController
  before_filter :must_be_invitee, :only => [:show, :update]
  skip_before_filter :check_for_app_request

  def create
    invites = []
    params[:to].each do |fb_id|
      invites << Invite.create(
        fb_id: fb_id,
        request_id: params[:request],
        roommate_id: current_user.id
      )
    end
    render json: invites
  end

  private

  def must_be_invitee
    redirect_to current_user_default_path unless invite.fb_id == current_user.fb_id
  end

  def inviter
    @inviter ||= invite.roommate
  end

  def invite
    @invite ||= Invite.find params[:id] rescue nil
  end
  helper_method :invite, :inviter
end
