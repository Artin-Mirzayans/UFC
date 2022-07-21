class FightsController < ApplicationController
  before_action :authorize_admin_or_mod!, except: [:destroy]
  before_action :authorize_admin!, only: [:destroy]
  def new
      @event = Event.find(params[:event_id])

      @fight = Fight.new
  end

  def create
      @event = Event.find(params[:event_id])
      @fight = @event.fights.new(fight_params)

      if @fight.save
        redirect_to @event
      
      else
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

    if @fight.update(fight_params)
      redirect_to @event
    else
      render :edit, status: :unprocessable_entity
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

  def up
    @fight = Fight.find(params[:fight_id])
    @event = Event.find(params[:event_id])

    @fight.move_higher

    @fights = @event.fights.where(placement: @fight.placement)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def down
    @fight = Fight.find(params[:fight_id])
    @event = Event.find(params[:event_id])

    
    @fight.move_lower

    @fights = @event.fights.where(placement: @fight.placement)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @fight = Fight.find(params[:fight_id])
    @event = Event.find(@fight.event_id)

    @fight.destroy

    redirect_to @event
  end

  private
  def fight_params
    params.require(:fight).permit(:f1, :f2, :placement)
  end

end