class PredictionsController < ApplicationController
  def submit_method
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])

    @fights = @event.fights.where(placement: @fight.placement)

    if @fight.methodpredictions.exists?(user_id: current_user.id)
      @prediction = @fight.methodpredictions.find_by(user_id: current_user.id)

      if @prediction.update(
           fighter_id: params[:fighter_id],
           method: methodprediction_params[:method],
           line: 100
         )
        puts "Successful Prediction Update!"
      else
        puts "Prediction did NOT update!"
      end

      respond_to { |format| format.turbo_stream }
    else
      @prediction =
        @fight.methodpredictions.new(
          user_id: current_user.id,
          event_id: params[:event_id],
          fighter_id: params[:fighter_id],
          method: methodprediction_params[:method],
          line: 100
        )

      if @prediction.save
        puts "New Prediction Created!"
      else
        puts "Oh poo! A new prediction could not be made!"
      end

      respond_to { |format| format.turbo_stream }
    end
  end

  def delete_method
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])
    @fights = @event.fights.where(placement: @fight.placement)

    @prediction = @fight.methodpredictions.find_by(user_id: current_user.id)

    if @prediction.valid?
      @prediction.destroy

      respond_to { |format| format.turbo_stream }
    else
      puts "Prediction cannot be deleted."
    end
  end

  private

  def methodprediction_params
    params.require(:methodprediction).permit(:method)
  end
end
