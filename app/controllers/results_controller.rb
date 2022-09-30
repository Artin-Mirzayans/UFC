class ResultsController < ApplicationController
  before_action :authorize_admin_or_mod!
  def new
    @event = Event.find(params[:event_id])
    @fights = @event.fights.where(placement: 0)
    @card = "MAIN"
  end

  def create
    @event = Event.find(params[:event_id])
    @fight = Fight.find(params[:fight_id])

    @fighter = Fighter.find(result_params[:fighter_id])

    @result =
      @fight.build_result(fighter: @fighter, method: result_params[:method])

    if @result.save
      puts "Result Saved"
    else
      puts @result.errors.full_messages
    end

    @card = @fight.placement
    @fights = @event.fights.where(placement: @card)

    respond_to { |format| format.turbo_stream }
  end

  def main
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 0)

    @card = "MAIN"

    respond_to { |format| format.turbo_stream }
  end

  def prelims
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 1)

    @card = "PRELIMS"

    respond_to { |format| format.turbo_stream }
  end

  def early
    @event = Event.find(params[:event_id])

    @fights = @event.fights.where(placement: 2)

    @card = "EARLY"

    respond_to { |format| format.turbo_stream }
  end

  def predictions
    @event = Event.find(params[:event_id])
    @fights = @event.fights

    @event.received_all_results?

    if !@event.errors.added? :name, "Waiting on all fight results."
      @fights.each do |fight|
        methodpredictions_ids = fight.methodpredictions.pluck(:id)
        distancepredictions_ids = fight.distancepredictions.pluck(:id)
        ScorePredictionsJob.perform_later(
          fight.id,
          methodpredictions_ids,
          distancepredictions_ids
        )
      end

      @event.update(status: "CONCLUDED")
      redirect_to @event
    else
      puts @event.errors.full_messages
    end
  end

  def reset
    @event = Event.find(params[:event_id])
    @fight_ids = @event.fights.where(placement: params[:card]).pluck(:id)
    Result.where(fight_id: @fight_ids).destroy_all

    @fights = @event.fights.where(placement: params[:card])
    @card = params[:card]
  end

  private

  def result_params
    params.require(:result).permit(:fighter_id, :method)
  end
end
