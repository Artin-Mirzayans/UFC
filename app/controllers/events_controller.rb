class EventsController < ApplicationController
    
    def index
      @event = Event.all
    end

    def new
      @event = Event.new

    end

    def create
      @event = Event.new(event_params)
      print params

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
    end


end

