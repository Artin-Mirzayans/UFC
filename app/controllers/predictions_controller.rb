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
        if @fight.distancepredictions.exists?(user_id: current_user.id)
          @distanceprediction =
            @fight.distancepredictions.find_by(user_id: current_user.id)
          @distanceprediction.delete
        end
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

    if @prediction && @prediction.valid?
      @prediction.destroy

      respond_to { |format| format.turbo_stream }
    else
      puts "Method Prediction cannot be deleted."
    end
  end

  def submit_distance
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])

    @fights = @event.fights.where(placement: @fight.placement)

    if @fight.distancepredictions.exists?(user_id: current_user.id)
      @prediction = @fight.distancepredictions.find_by(user_id: current_user.id)

      if @prediction.update(
           distance: distanceprediction_params[:distance],
           line: 100
         )
        puts "Successful Prediction Update!"
      else
        puts "Prediction did NOT update!"
      end

      respond_to { |format| format.turbo_stream }
    else
      @prediction =
        @fight.distancepredictions.new(
          user_id: current_user.id,
          event_id: params[:event_id],
          fight_id: params[:fight_id],
          distance: distanceprediction_params[:distance],
          line: 100
        )

      if @prediction.save
        puts "New Prediction Created!"
        if @fight.methodpredictions.exists?(user_id: current_user.id)
          @methodprediction =
            @fight.methodpredictions.find_by(user_id: current_user.id)
          @methodprediction.delete
        end
      else
        puts "Here you go!" + distanceprediction_params[:distance]
        puts distanceprediction_params[:distance].class
        puts @prediction.errors.full_messages
        puts "Oh poo! A new prediction could not be made!"
      end

      respond_to { |format| format.turbo_stream }
    end
  end

  def delete_distance
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])
    @fights = @event.fights.where(placement: @fight.placement)

    @prediction = @fight.distancepredictions.find_by(user_id: current_user.id)

    if @prediction && @prediction.valid?
      @prediction.destroy

      respond_to { |format| format.turbo_stream }
    else
      puts "Distance Prediction cannot be deleted."
    end
  end

  private

  def methodprediction_params
    params.require(:methodprediction).permit(:method)
  end

  private

  def distanceprediction_params
    params.require(:distanceprediction).permit(:distance)
  end
end
