class PredictionsController < ApplicationController

  def submit_method
    @event = Event.find(params[:event_id])
    @fight = @event.fights.find(params[:fight_id])
    @fighter = @event.fighters.find(params[:fighter_id])
    @method = params[:method]
    @user_event_budget =
      UserEventBudget.find_by(user: current_user, event: @event)

    #Odds for method has been posted?
    if @fight.odd.posted?(@method)
      # Method prediction already exists
      if @fight.methodpredictions.exists?(user: current_user)
        @prediction = @fight.methodpredictions.find_by(user: current_user)

        # Attempt to delete prediction
        if @prediction.method == @method && @prediction.fighter == @fighter
          if @prediction.valid?
            @prediction.destroy
            @user_event_budget.increase_budget(@prediction.wager)
            @user_event_budget.decrease_wagered(@prediction.wager)
          else
            puts @prediction.errors.full_messages
            head:ok
          end
          # Attempt to Update prediction
        else
          @line = @fight.odd.retrieve(@method)
          if @prediction.update(
               fighter: @fighter,
               method: @method,
               created_at: @prediction.created_at,
               line: @line
             )
            puts @prediction.errors.full_messages
          else
          end
        end
      elsif @fight.distancepredictions.find_by(user: current_user).nil?
        # Fresh Method Prediction (Distance prediction does not exist)
        @line = @fight.odd.retrieve(@method)
        @wager = @user_event_budget.set_default_wager(current_user, @event)

        @prediction =
          @fight.methodpredictions.new(
            user: current_user,
            event: @event,
            fighter: @fighter,
            method: @method,
            line: @line,
            wager: @wager
          )
        if @prediction.save
          @user_event_budget.decrease_budget(@wager)
          @user_event_budget.increase_wagered(@wager)
        else
          puts @prediction.errors.full_messages
        end
      else
        #Attempting to change distance prediction to method prediction
        @distance_prediction =
          @fight.distancepredictions.find_by(user: current_user)
        if @distance_prediction.valid?
          @wager = @distance_prediction.wager
          @line = @fight.odd.retrieve(@method)

          @prediction =
            @fight.methodpredictions.new(
              user: current_user,
              event: @event,
              fighter: @fighter,
              method: @method,
              line: @line,
              wager: @wager,
              created_at: @distance_prediction.created_at
            )

          if @prediction.save
            @distance_prediction.delete
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
    @distance = params[:method]
    @user_event_budget =
      UserEventBudget.find_by(user: current_user, event: @event)

    if @distance == "true"
      distance = "yes_decision"
    elsif @distance == "false"
      distance = "no_decision"
    end

    #Odds for method has been posted?
    if distance.present? && @fight.odd.posted?(distance)
      # Distance prediction already exists
      if @fight.distancepredictions.exists?(user: current_user)
        @prediction = @fight.distancepredictions.find_by(user: current_user)

        # User trying to delete prediction
        if @prediction.distance.to_s.downcase == @distance
          if @prediction.valid?
            @prediction.delete
            @user_event_budget.increase_budget(@prediction.wager)
            @user_event_budget.decrease_wagered(@prediction.wager)
          else
            puts @prediction.errors.full_messages
            head:ok
          end

          # see if we can update the method prediction!
        else
          @line = @fight.odd.retrieve(distance)
          if @prediction.update(
               distance: @distance,
               created_at: @prediction.created_at,
               line: @line
             )
          end
        end
      elsif @fight.methodpredictions.find_by(user: current_user).nil?
        # Fresh Distance Prediction (Method prediction does not exist)
        @line = @fight.odd.retrieve(distance)
        @wager = @user_event_budget.set_default_wager(current_user, @event)

        @prediction =
          @fight.distancepredictions.new(
            user: current_user,
            event: @event,
            fight: @fight,
            distance: @distance,
            line: @line,
            wager: @wager
          )
        if @prediction.save
          @user_event_budget.decrease_budget(@wager)
          @user_event_budget.increase_wagered(@wager)
        else
          puts @prediction.errors.full_messages
        end
      else
        #Attempting to change method prediction to distance prediction
        @method_prediction =
          @fight.methodpredictions.find_by(user: current_user)
        if @method_prediction.valid?
          @wager = @method_prediction.wager
          @line = @fight.odd.retrieve(distance)

          @prediction =
            @fight.distancepredictions.new(
              user: current_user,
              event: @event,
              distance: @distance,
              line: @line,
              wager: @wager,
              created_at: @method_prediction.created_at
            )

          if @prediction.save
            @method_prediction.delete
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

  def wager
    @event = Event.find(params[:event_id])
    @fight = @event.fights.find(params[:fight_id])
    @wager = params[:wager].to_i
    @user_event_budget =
      UserEventBudget.find_by(user: current_user, event: @event)

    if @fight.methodpredictions.exists?(user: current_user)
      @prediction = @fight.methodpredictions.find_by(user: current_user)
    else
      @prediction = @fight.distancepredictions.find_by(user: current_user)
    end

    difference = @prediction.wager - @wager
    if @user_event_budget.sufficient_funds?(difference) && @prediction.valid? &&
         @wager.positive?
      if @prediction.update(wager: @wager)
        if difference.positive?
          @user_event_budget.increase_budget(difference)
          @user_event_budget.decrease_wagered(difference)
        else
          @user_event_budget.decrease_budget(-difference)
          @user_event_budget.increase_wagered(-difference)
        end
      else
        puts @prediction.errors.full_messages
      end
    else
      puts @prediction.errors.full_messages
    end
    @card = @fight.placement
    @fights = @event.fights.where(placement: @card)

    respond_to { |format| format.turbo_stream }
  end
end
