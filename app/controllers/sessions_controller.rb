class SessionsController < ApplicationController
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
      redirect_to @invite
    else
      redirect_to_target_or_default
    end
  end
end
