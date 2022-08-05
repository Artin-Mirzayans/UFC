class PredictionsController < ApplicationController
    def submit_method
        @event = Event.find(params[:event_id])
        @fight = Fight.find(params[:fight_id])

        if @fight.methodpredictions.exists?(user_id: current_user.id)
            puts "PREDICTION ALREADY EXISTS"

            @prediction = @fight.methodpredictions.find_by(user_id: current_user.id)

            if @prediction.update(fighter_id: params[:fighter_id], method: methodprediction_params[:method], line: 100)

                respond_to do |format|
                    format.turbo_stream
                end

            else 
                puts "This did not update! Woopsy doo!"
            end

            
        else
            @prediction = @fight.methodpredictions.new(user_id: current_user.id, fighter_id: params[:fighter_id], method: methodprediction_params[:method], line: 100)

            if @prediction.save

                @fights = @event.fights.where(placement: @fight.placement)

                respond_to do |format|
                    format.turbo_stream 
                end  
            else 
                puts "Oh poo! The prediction didn't save!"
            end
        end
    end

    private
    def methodprediction_params
        params.require(:methodprediction).permit(:method)
    end

end