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
    @events = Event.all
  end

  def show
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 0)

    @card = "MAIN"

    @method = Methodprediction.new
  end

  def main
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 0)

    @card = "MAIN"

    respond_to { |format| format.turbo_stream }
  end

  def prelims
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 1)

    @card = "PRELIMS"

    respond_to { |format| format.turbo_stream }
  end

  def early
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 2)

    @card = "EARLY"

    respond_to { |format| format.turbo_stream }
  end

  def edit
    @event = Event.find(params[:event_id])
  end

  def update
    @event = Event.find(params[:event_id])

    if @event.update(event_params)
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
    params.require(:event).permit(:name, :location, :date, :category, :status)
  end
end
