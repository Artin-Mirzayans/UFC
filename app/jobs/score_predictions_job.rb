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
    @incorrect_predictions = predictions - @correct_predictions

    score_predictions(@correct_predictions, @incorrect_predictions)
  end

  def evaluate_distance_predictions(fight, predictions)
    if fight.result.method == "DECISION" || fight.result.method == "DRAW"
      @correct_predictions = predictions.where(distance: true)
    else
      @correct_predictions = predictions.where(distance: false)
    end

    @incorrect_predictions = predictions - @correct_predictions

    score_predictions(@correct_predictions, @incorrect_predictions)
  end

  def score_predictions(correct_predictions, incorrect_predictions)
    unless correct_predictions.blank?
      correct_predictions.each do |prediction|
        puts prediction.fighter.name
        prediction.user.update(points: prediction.user.points + 100)
      end
    end
    unless incorrect_predictions.blank?
      incorrect_predictions.each do |prediction|
        puts prediction.fighter.name
        prediction.user.update(points: prediction.user.points - 100)
      end
    end
  end
end

#testing
# @cp_any = predictions.where(method: "ANY").where(fighter: f.result.fighter)
# @cp_method = predictions.where(method: f.result.method, fighter: f.result.fighter)
# @cp = cp_any + cp_method
