class FightsController < ApplicationController
  before_action :authorize_admin_or_mod!
  def new
    @event = Event.find(params[:event_id])

    @fight = Fight.new
  end

  def create
    @event = Event.find(params[:event_id])

    @fight =
      @event.fights.new(
        red: Fighter.find_by(name: fight_params[:red]),
        blue: Fighter.find_by(name: fight_params[:blue]),
        placement: fight_params[:placement]
      )

    if @fight.save
      redirect_to @event
    else
      print(@fight.errors.full_messages)
      render :new
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @fight = @event.fights.find(params[:fight_id])
  end

  def update
    @event = Event.find(params[:event_id])
    @fight = @event.fights.find(params[:fight_id])

    if @fight.update(placement: fight_params[:placement])
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def up
    @fight = Fight.find(params[:fight_id])
    @event = Event.find(params[:event_id])

    @fight.move_higher

    @card = @fight.placement

    @fights = @event.fights.where(placement: @card)

    respond_to { |format| format.turbo_stream }
  end

  def down
    @fight = Fight.find(params[:fight_id])
    @event = Event.find(params[:event_id])

    @fight.move_lower

    @card = @fight.placement

    @fights = @event.fights.where(placement: @card)

    respond_to { |format| format.turbo_stream }
  end

  def destroy
    @fight = Fight.find(params[:fight_id])
    @event = Event.find(@fight.event_id)

    @card = @fight.placement

    @fights = @event.fights.where(placement: @card)

    @fight.destroy
  end

  private

  def fight_params
    params.require(:fight).permit(:red, :blue, :placement)
  end
end
