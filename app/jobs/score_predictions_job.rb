class ScorePredictionsJob < ApplicationJob
  queue_as :default

  def perform(fight_id, methodpredictions_ids, distancepredictions_ids)
    fight = Fight.find(fight_id)
    methodpredictions = Methodprediction.where(id: methodpredictions_ids)
    distancepredictions = Distanceprediction.where(id: distancepredictions_ids)
    evaluate_method_predictions(fight, methodpredictions)
    evaluate_distance_predictions(fight, distancepredictions)
  end

  def evaluate_method_predictions(fight, predictions)
    @correct_win_by_any_predictions =
      predictions.where(method: "ANY").where(fighter: fight.result.fighter)
    @correct_win_by_method_predictions =
      predictions.where(
        method: fight.result.method,
        fighter: fight.result.fighter
      )

    @correct_predictions =
      @correct_win_by_any_predictions + @correct_win_by_method_predictions

    score_predictions(@correct_predictions)
  end

  def evaluate_distance_predictions(fight, predictions)
    if fight.result.method == "DECISION" || fight.result.method == "DRAW"
      @correct_predictions = predictions.where(distance: true)
    else
      @correct_predictions = predictions.where(distance: false)
    end

    score_predictions(@correct_predictions)
  end

  def score_predictions(correct_predictions)
    unless correct_predictions.blank?
      correct_predictions.each do |prediction|
        prediction.update(is_correct: true)
        prediction
          .user
          .user_event_budgets
          .find_by(event: prediction.event)
          .update_winnings((prediction.wager * prediction.line).round)
      end
    end
  end
end
