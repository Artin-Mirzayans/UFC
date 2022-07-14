class FightsController < ApplicationController

  def new
      @fight = Fight.new
      @event_id = params[:event_id]
    end

  def create

      @event = Event.find(params[:event_id])
      @fight = @event.fights.new(fight_params)

      if @fight.save
        redirect_to root_path
      
      else
        render :new

      end

  end

  private
  def event_params
    params.require(:event).permit(:name, :location, :date)
  end

  private
  def fight_params
    params.require(:fight).permit(:f1, :f2, :placement)
  end

end