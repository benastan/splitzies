class ExpensesController < ApplicationController
  before_filter :must_be_logged_in

  def recover
    @expense = Expense.with_deleted.find(params[:id]) rescue nil

    respond_to do |format|
      unless @expense.nil?
        if @expense.deleted? && @expense.recover
          Notification.notify!(@expense.roommates, current_user, :recovered, @expense)
          format.html { redirect_to @expense, notice: "This expense has been restored" }
          format.json { render json: @expense }
        else
          format.html { render :edit }
          format.json { render json: @expense }
        end
      else
        format.html { redirect_to expenses_path, status: :not_found }
        format.json { render nothing: true, status: :not_found }
      end
    end
  end

  def index
    @expenses = current_user.household.expenses

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expenses }
    end
  end

  def show
    @expense = Expense.with_deleted.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    @expense = current_user.household.expenses.new(
      created_by_roommate_id: current_user.id,
      roommate_id: current_user.id
    )

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expense }
    end
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.find(params[:id])
  end

  # POST /expenses
  # POST /expenses.json
  def create
    roommates = params[:expense][:roommate_expenses]
    params[:expense].delete :roommate_expenses
    @expense = Expense.create params[:expense]

    roommates.values.each { |r|
      @expense.roommate_expenses.new(r)
    }

    respond_to do |format|
      if @expense.save
        Notification.notify!(@expense.roommates, current_user, :created, @expense)
        format.html { redirect_to expenses_path, notice: 'Expense was successfully created.' }
        format.json { render json: @expense, status: :created, location: @expense }
      else
        format.html { render action: "new" }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.json
  def update
    roommates = params[:expense][:roommate_expenses]
    params[:expense].delete :roommate_expenses
    @expense = Expense.find(params[:id])
    @expense.update_attributes params[:expense]
    roommates.values.each { |r|
      re = RoommateExpense.find r['id']
      re.update_attributes r
    }

    Notification.notify! @expense.roommates, current_user, :edited, @expense

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        format.html { redirect_to expenses_path, notice: 'Expense was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    Notification.notify!(@expense.roommates, current_user, :deleted, @expense)

    respond_to do |format|
      format.html { redirect_to expenses_url }
      format.json { head :no_content }
    end
  end

  private
end
