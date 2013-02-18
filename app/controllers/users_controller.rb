class UsersController < ApplicationController
  before_filter :must_be_logged_in, :except => [ :new, :create ]
  skip_before_filter :check_for_app_request, :only => [ :new, :create, :update ]

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

    if params[:roommate][:household_id]
      @household = Household.find params[:roommate][:household_id]
      @user.household = @household
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

  def new
    @invite = Invite.find_by_sha(params[:i]) rescue nil
    @user = Roommate.new(
      email: @invite.email,
      household_id: @invite.roommate.household.id
    )
  end

  def create
    @invite = Invite.find_by_sha(params[:i]) rescue nil
    @user = Roommate.new(params[:roommate])
    @user.state = 'active'
    if @user.save
      @invite.update_attribute(:open, false)
      set_current_user @user
      redirect_to current_user_default_path
    else
      render :new
    end
  end
end
