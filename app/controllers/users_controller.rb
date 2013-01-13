class UsersController < ApplicationController
  before_filter :must_be_logged_in

  def friends
    facebook = Koala::Facebook::API.new current_user.oauth_token
    @friends = facebook.get_connections('me', 'friends').sort { |a, b| a['name'] <=> b['name'] }
  end

  def update
    @user = User.find params[:id] rescue nil

    unless @user
      @user = current_user
    end

    if params[:invite]
      @invite = Invite.find params[:invite][:id] rescue nil
    end

    if @invite
      @invite.update_attribute :open, false
      @user.state = 'active'
    end

    respond_to do |format|
      if @user.update_attributes params[:roommate]
        format.html { redirect_to current_user_default_path, notice: 'Welcome!' if @invite }
        format.json { render json: @user, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user, status: :unprocessable_entity }
      end
    end
  end

  def next_step
    current_user.next_step

    respond_to do |format|
      format.html { redirect_to current_user_default_path }
      format.json { render json: current_user, :location => current_user_default_path }
    end
  end
end
