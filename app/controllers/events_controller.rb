class EventsController < ApplicationController
  before_action :authorize_admin_or_mod!,
                except: %i[index show main prelims early destroy]
  before_action :authorize_admin!, only: [:destroy]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to root_path
    else
      render :new
    end
  end

  def index
    @events = Event.where(status: "UPCOMING").or(Event.where(status: "INPROGRESS")).order('date') 
    @event_status = "UPCOMING"
  end

  def upcoming
    @events = Event.where(status: "UPCOMING").or(Event.where(status: "INPROGRESS")).order('date')
    @event_status = "UPCOMING"
    respond_to { |format| format.turbo_stream }
  end

  def concluded
    @events = Event.where(status: "CONCLUDED").order('date DESC')
    @event_status = "CONCLUDED"
    respond_to { |format| format.turbo_stream }
  end

  def show
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 0)

    @card = "MAIN"

    @user_event_budget =
      UserEventBudget.find_or_create_by(user: current_user, event: @event)
  end

  def main
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 0)

    @card = "MAIN"

    @user_event_budget =
    UserEventBudget.find_or_create_by(user: current_user, event: @event)

    respond_to { |format| format.turbo_stream }
  end

  def prelims
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 1)

    @card = "PRELIMS"

    @user_event_budget =
    UserEventBudget.find_or_create_by(user: current_user, event: @event)

    respond_to { |format| format.turbo_stream }
  end

  def early
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 2)

    @card = "EARLY"

    @user_event_budget =
    UserEventBudget.find_or_create_by(user: current_user, event: @event)

    respond_to { |format| format.turbo_stream }
  end

  def edit
    @event = Event.find(params[:event_id])
  end

  def update
    @event = Event.find(params[:event_id])

    if @event.update(event_params)
      @event.schedule_cards(@event.saved_changes)
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:event_id])

    @event.destroy

    redirect_to root_path
  end

  private

  def event_params
    params.require(:event).permit(
      :apiname,
      :name,
      :red,
      :blue,
      :location,
      :date,
      :category,
      :status,
      :main,
      :prelims,
      :early,
      :red_image,
      :blue_image
    )
  end
end
