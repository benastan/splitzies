class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_for_app_request, :unless => :format_json?

  private

  def must_be_logged_in
    redirect_to '/auth/facebook' if current_user.nil?
  end

  def current_user
    @current_user ||= Roommate.find session[:current_user_id] rescue nil
  end
  helper_method :current_user

  def set_current_user user = nil
    if user
      session[:current_user_id] = user.id
    else
      session[:current_user_id] = nil
    end
  end

  def redirect_to_target_or_default url = nil
    redirect_to session[:redirect_url] || url || current_user_default_path
  end

  def current_user_invites
    unless @current_user_invites
      invites = Invite.scoped.where(:open => true)
      @current_user_invites = invites.where(:fb_id => current_user.fb_id)
      unless session[:request_ids].nil?
        session_invite_ids = session[:request_ids].split ','
        @current_user_invites += invites.where("request_id in (?)", session_invite_ids)
      end
    end
    @current_user_invites
  end

  def current_user_default_path
    if current_user.nil?
      login_path
    else
      if current_user.active?
        expenses_path
      elsif current_user.invite_roommates?
        invite_friends_path
      elsif current_user.create_household?
        new_household_path
      end
    end
  end
  helper_method :current_user_default_path

  def check_for_app_request
    if current_user.nil?
      if params[:request_ids]
        session[:request_ids] = params[:request_ids]
      end
      redirect_to '/auth/facebook'
    else
      unless current_user_invites.empty?
        redirect_to current_user_invites.last
      end
    end
  end

  def set_api_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end

  def format_json?
    request.format.json?
  end
end
