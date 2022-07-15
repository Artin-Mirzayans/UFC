class FightsController < ApplicationController

  def new
      @fight = Fight.new
      @event_id = params[:event_id]
    end

  def create

      @event = Event.find(params[:event_id])
      @fight = @event.fights.new(fight_params)

      if @fight.save
        redirect_to event_path(params[:event_id])
      
      else
        render :new

      end

  end

  def search
    if params[:search_query].present?
      @fighters = Fighter.where("name ilike ?", "%#{params[:search_query]}%").limit(10)
    else
      @fighters = Fighter.all.limit(5)
    end

    respond_to do |format|
      if params[:search_query].present?
        format.turbo_stream { render turbo_stream: turbo_stream.update('search_results', partial: 'fights/search_result') }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @fight = Fight.find(params[:fight_id])
    
    @event_id = params[:event_id]
    @fight_id = params[:fight_id]
  end

  def update
    @fight = Fight.find(params[:fight_id])

    if @fight.update(fight_params)
      redirect_to event_path(params[:event_id])
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fight = Fight.find(params[:fight_id])
    @fight.destroy

    redirect_to event_path(params[:event_id])
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