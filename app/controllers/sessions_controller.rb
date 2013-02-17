class SessionsController < ApplicationController
  before_filter :must_not_be_logged_in, except: [:logout, :index, :new]
  before_filter :set_api_headers, only: [ :index, :create ], if: :'format_json?'
  skip_before_filter :check_for_app_request, only: :create
  before_filter :cant_be_logged_in, only: [ :new, :create ]

  def logout
    set_current_user nil
    redirect_to '/'
  end

  def new
    @user = Roommate.new
  end

  def create
    respond_to do |format|
      if params[:roommate]
        @user = Roommate.find_by_email(params[:roommate][:email])
        if @user.authenticate(params[:roommate][:password])
          set_current_user @user
          format.html { redirect_to current_user_default_path }
        else
          format.html { render :new }
        end
      else
        format.html {
          data = session_data_from_omniauth
          user = find_or_initialize_user data

          if session[:request_ids]
            @invite = session[:request_ids].split(',').collect { |id|
              Invite.find_by_request_id id
            }.reject(&:nil?).select(&:open).last
            session.delete :request_ids
          elsif user.household_id.nil?
            @invite = Invite.find_by_fb_id user.fb_id rescue nil
          end

          redirect_to @invite || current_user_default_path
        }

        format.json {
          oauth_token = params[:access_token]
          oauth_expiration = params[:access_expires]
          if oauth_token
            data = session_data_from_graph params
            user = find_or_initialize_user data
            set_current_user user
          else
            user = current_user
            unless user
              return render nothing: true, status: :not_found
            end
          end
          render json: user
        }
      end
    end
  end

  def index
    respond_to do |format|
      format.json {
        if current_user.nil?
          render nothing: true, status: :not_found
        else
          render json: current_user
        end
      }

      format.html { redirect_to current_user.nil? ?  current_user_default_path : '/auth/facebook' }
    end
  end

  private

  def must_not_be_logged_in
    redirect_to current_user_default_path unless current_user.nil?
  end

  def session_data_from_omniauth
    data = request.env['omniauth.auth']
    info = data[:info]
    [:email, :first_name, :last_name].each do |attr|
      data[attr] = info[attr]
    end
    data[:oauth_token] = data[:credentials][:token]
    data[:oauth_expiration] = data[:credentials][:expires_at]
    data
  end

  def session_data_from_graph auth
    oauth_token = auth[:access_token]
    oauth_expiration = auth[:access_expires].to_i
    data = {}
    graph = Koala::Facebook::API.new(oauth_token)
    me = graph.get_object('me')
    data[:uid] = me['id']
    %w(email first_name last_name).each do |attr|
      data[attr.to_sym] = me[attr]
    end
    data[:oauth_token] = oauth_token
    data[:oauth_expiration] = oauth_expiration
    data
  end

  def find_or_initialize_user data
    user = Roommate.find_or_initialize_by_fb_id(data[:uid]) rescue nil

    user.password = user.password_confirmation = ""
    user.password_digest = "facebook-authorized account"

    user.update_attributes(
      first_name: data[:first_name],
      last_name: data[:last_name],
      email: data[:email],
      oauth_token: data[:oauth_token],
      oauth_expiration: Time.at(data[:oauth_expiration]),
    )

    set_current_user user

    user
  end
end
