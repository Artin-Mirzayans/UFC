class PredictionsController < ApplicationController
  def submit_method
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])
    @fighter = Fighter.find(params[:fighter_id])

    # Method prediction already exists
    if @fight.methodpredictions.exists?(user: current_user)
      @prediction = @fight.methodpredictions.find_by(user: current_user)

      # User trying to delete prediction
      if @prediction.method == methodprediction_params[:method] &&
           @prediction.fighter == @fighter
        if @prediction.valid?
          @prediction.destroy
        else
          puts "Method Prediction cannot be deleted."
        end
      elsif @prediction.update(
            fighter: @fighter,
            method: methodprediction_params[:method],
            created_at: @prediction.created_at
          )
        @fight.distancepredictions.find_by(user: current_user).try(:delete)
      else
        puts "Update Method Prediction Failed!"
      end

      # Fresh Method Prediction (Could be trying to change from distance prediction to method prediction OR first prediction made on fight)
    else
      @prediction =
        @fight.methodpredictions.new(
          user: current_user,
          event_id: params[:event_id],
          fighter_id: params[:fighter_id],
          method: methodprediction_params[:method],
          line: 100
        )

      if @prediction.save
        # Checking if .. Changing Prediction from Distance
        @fight.distancepredictions.find_by(user: current_user).try(:delete)
      else
        puts "Error Creating Brand New Method Prediction!"
      end
    end

    @card = @fight.placement
    @fights = @event.fights.where(placement: @card)

    respond_to { |format| format.turbo_stream }
  end

  def submit_distance
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])

    @fights = @event.fights.where(placement: @fight.placement)

    # Method prediction already exists
    if @fight.distancepredictions.exists?(user: current_user)
      @prediction = @fight.distancepredictions.find_by(user: current_user)
      # User trying to delete prediction
      if @prediction.distance.to_s.downcase ==
           distanceprediction_params[:distance]
        if @prediction.valid?
          @prediction.delete
        else
          puts "Distance Prediction cannot be deleted."
        end

        # see if we can update the method prediction!
      elsif @prediction.update(
            distance: distanceprediction_params[:distance],
            created_at: @prediction.created_at
          )
        @fight.methodpredictions.find_by(user: current_user).try(:delete)
      else
        puts "Update Distance Prediction Failed!"
      end

      # Fresh Distance Prediction (Could be trying to change from distance prediction to method prediction OR first prediction made on fight)
    else
      @prediction =
        @fight.distancepredictions.new(
          user: current_user,
          event_id: params[:event_id],
          fight: @fight,
          distance: distanceprediction_params[:distance],
          line: 100
        )

      if @prediction.save
        # Checking if .. Changing Prediction from Distance
        @fight.methodpredictions.find_by(user: current_user).try(:delete)
      else
        puts "Error Creating Brand New Distance Prediction!"
      end
    end

    @card = @fight.placement
    @fights = @event.fights.where(placement: @card)

    respond_to { |format| format.turbo_stream }
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
