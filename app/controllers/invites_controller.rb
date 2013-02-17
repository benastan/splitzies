class InvitesController < ApplicationController
  before_filter :must_be_invitee, :only => [:show, :update]
  skip_before_filter :check_for_app_request

  def create
    invites = []
    if params[:to].nil?
      emails = params[:invites][:email_addresses].split(/,\s?/)
      invites = []
      errors = {}
      emails.collect do |email|
        invite = Invite.new(
          email: email,
          roommate_id: current_user.id
        )
        if invite.save
          invites << invite
        else
          errors[email] = invite.errors
        end
      end
    else
      invites = params[:to].collect do |fb_id|
        Invite.create(
          fb_id: fb_id,
          request_id: params[:request],
          roommate_id: current_user.id
        )
      end
    end

    if errors.keys.empty?
      render json: invites
    else
      headers['X-Error-Messages'] = errors.to_json
      render json: invites, status: :unprocessable_entity
    end
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
