class SessionsController < ApplicationController
  before_filter :must_not_be_logged_in, except: :logout

  def logout
    set_current_user nil
    render :new
  end

  def create
    data = request.env['omniauth.auth']
    info = data[:info]
    fb_id = data[:uid]
    user = Roommate.find_by_fb_id(fb_id) rescue nil

    unless user
      user = Roommate.create(
        first_name: info[:first_name],
        last_name: info[:last_name],
        email: info[:email],
        fb_id: fb_id
      )
    end

    user.update_attributes(
      oauth_token: data[:credentials][:token],
      oauth_expiration: Time.at(data[:credentials][:expires_at])
    )

    set_current_user user

    if session[:request_ids]
      @invite = session[:request_ids].split(',').collect { |id|
        Invite.find_by_request_id id
      }.reject(&:nil?).select(&:open).last
      session.delete :request_ids
    elsif user.household_id.nil?
      @invite = Invite.fnd_by_fb_id user.fb_id rescue nil
    end

    redirect_to @invite || current_user_default_path
  end

  private

  def must_not_be_logged_in
    redirect_to current_user_default_path unless current_user.nil?
  end
end
