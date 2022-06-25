class EventsController < ActionController::Base
    
    def index
    end

    def new
        @fighters = Fighter.all
    end

    def search

    end

end

