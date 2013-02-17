class RoommateNotificationsController < ApplicationController
  def seen
    @roommate_notification = RoommateNotification.find params[:id]
    @roommate_notification.seen!

    respond_to do |format|
      format.json { render json: @roommate_notification }
      format.html { redirect_to @roommate_notification.notification.axis }
    end
  end

  # GET /roommate_notifications
  # GET /roommate_notifications.json
  def index
    @roommate_notifications = RoommateNotification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roommate_notifications }
    end
  end

  # GET /roommate_notifications/1
  # GET /roommate_notifications/1.json
  def show
    @roommate_notification = RoommateNotification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @roommate_notification }
    end
  end

  # GET /roommate_notifications/new
  # GET /roommate_notifications/new.json
  def new
    @roommate_notification = RoommateNotification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @roommate_notification }
    end
  end

  # GET /roommate_notifications/1/edit
  def edit
    @roommate_notification = RoommateNotification.find(params[:id])
  end

  # POST /roommate_notifications
  # POST /roommate_notifications.json
  def create
    @roommate_notification = RoommateNotification.new(params[:roommate_notification])

    respond_to do |format|
      if @roommate_notification.save
        format.html { redirect_to @roommate_notification, notice: 'Roommate notification was successfully created.' }
        format.json { render json: @roommate_notification, status: :created, location: @roommate_notification }
      else
        format.html { render action: "new" }
        format.json { render json: @roommate_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roommate_notifications/1
  # PUT /roommate_notifications/1.json
  def update
    @roommate_notification = RoommateNotification.find(params[:id])

    respond_to do |format|
      if @roommate_notification.update_attributes(params[:roommate_notification])
        format.html { redirect_to @roommate_notification, notice: 'Roommate notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @roommate_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roommate_notifications/1
  # DELETE /roommate_notifications/1.json
  def destroy
    @roommate_notification = RoommateNotification.find(params[:id])
    @roommate_notification.destroy

    respond_to do |format|
      format.html { redirect_to roommate_notifications_url }
      format.json { head :no_content }
    end
  end
end
