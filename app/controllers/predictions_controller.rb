class PredictionsController < ApplicationController
  def submit_method
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])
    @fighter = Fighter.find(params[:fighter_id])
    @method = methodprediction_params[:method]

    #Odds for method has been posted?
    if @fight.odd.posted?(@method)
      # Method prediction already exists
      if @fight.methodpredictions.exists?(user: current_user)
        @prediction = @fight.methodpredictions.find_by(user: current_user)

        # Attempt to delete prediction
        if @prediction.method == @method && @prediction.fighter == @fighter
          if @prediction.valid?
            @prediction.destroy
          else
            puts @prediction.errors.full_messages
          end
          # Attempt to Update prediction
        else
          @line = @fight.odd.retrieve(@method)
          if @prediction.update(
               fighter: @fighter,
               method: methodprediction_params[:method],
               created_at: @prediction.created_at,
               line: @line
             )
            puts @prediction.errors.full_messages
          else
          end
        end

        # Fresh Method Prediction (Could be trying to change from distance prediction to method prediction OR first prediction made on fight)
      else
        @distance_prediction =
          @fight.distancepredictions.find_by(user: current_user)

        # Check if there is an existing distance prediction
        if @distance_prediction.nil? || @distance_prediction.valid?
          @line = @fight.odd.retrieve(@method)
          @prediction =
            @fight.methodpredictions.new(
              user: current_user,
              event_id: params[:event_id],
              fighter_id: params[:fighter_id],
              method: methodprediction_params[:method],
              line: @line
            )
          if @prediction.save
            @fight.distancepredictions.find_by(user: current_user).try(:delete)
          else
            puts @prediction.errors.full_messages
          end
        else
          puts @distance_prediction.errors.full_messages
        end
      end
    else
      puts "Betting line has not been posted!"
    end # check if line is posted
    @card = @fight.placement
    @fights = @event.fights.where(placement: @card)
    respond_to { |format| format.turbo_stream }
  end

  def submit_distance
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])

    if distanceprediction_params[:distance] == "true"
      decision_bool = "yes"
    elsif distanceprediction_params[:distance] == "false"
      decision_bool = "no"
    else
      decision_bool = nil
    end

    #Odds for method has been posted?
    if !decision_bool.nil? && @fight.odd.posted?("#{decision_bool}_decision")
      # Method prediction already exists
      if @fight.distancepredictions.exists?(user: current_user)
        @prediction = @fight.distancepredictions.find_by(user: current_user)

        # User trying to delete prediction
        if @prediction.distance.to_s.downcase ==
             distanceprediction_params[:distance]
          if @prediction.valid?
            @prediction.delete
          else
            puts @prediction.errors.full_messages
          end

          # see if we can update the method prediction!
        else
          @odds = @fight.odd.retrieve("#{decision_bool}_decision")
          if @prediction.update(
               distance: distanceprediction_params[:distance],
               created_at: @prediction.created_at,
               line: @odds
             )
          end
        end

        # Fresh Distance Prediction (Could be trying to change from distance prediction to method prediction OR first prediction made on fight)
      else
        @method_prediction =
          @fight.methodpredictions.find_by(user: current_user)
        # Check if there is an existing method prediction
        if @method_prediction.nil? || @method_prediction.valid?
          @odds = @fight.odd.retrieve("#{decision_bool}_decision")
          @prediction =
            @fight.distancepredictions.new(
              user: current_user,
              event_id: params[:event_id],
              fight: @fight,
              distance: distanceprediction_params[:distance],
              line: @odds
            )

          if @prediction.save
            # Delete method prediction if exists when changing to distance prediction
            @fight.methodpredictions.find_by(user: current_user).try(:delete)
          else
            puts @prediction.errors.full_messages
          end
        else
          puts @method_prediction.errors.full_messages
        end
      end
    else
      puts "Betting Odds have not been posted!"
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
