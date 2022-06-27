class EventsController < ApplicationController
    
    def index
    end

    def new
      if params[:search_query].present?
        @fighters = Fighter.where("name ilike ?", "%#{params[:search_query]}%")
      else
        @fighters = Fighter.all.limit(5)
      end
  
      respond_to do |format|
        if params[:search_query].present?
          format.turbo_stream { render turbo_stream: turbo_stream.update('search_results', partial: 'events/search_result') }
        else
          format.html { render :new }
        end
      end
    end

end

