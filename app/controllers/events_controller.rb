class EventsController < ApplicationController
    
    def index
      @event = Event.all
    end

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

    def update

    end

    def show
      @event = Event.find(params[:event_id])
      
      @fights = @event.fights.where(placement: 0)
    end

    def main
      @event = Event.find(params[:event_id])
  
      @fights = @event.fights.where(placement: 0)
  
      respond_to do |format|
        format.turbo_stream
      end
    end

    def prelims
      @event = Event.find(params[:event_id])
  
      @fights = @event.fights.where(placement: 1)
  
      respond_to do |format|
        format.turbo_stream
        end
    end

    private
    def event_params
      params.require(:event).permit(:name, :location, :date)
    end


end

