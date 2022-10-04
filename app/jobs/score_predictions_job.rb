class ScorePredictionsJob < ApplicationJob
  queue_as :default

  def perform(fight_id, methodpredictions_ids, distancepredictions_ids)
    fight = Fight.find(fight_id)
    methodpredictions = Methodprediction.where(id: methodpredictions_ids)
    distancepredictions = Distanceprediction.where(id: distancepredictions_ids)
    if fight.result.method == "nc"
      void_predictions(
        fight,
        fight.event,
        methodpredictions,
        distancepredictions
      )
    else
      evaluate_method_predictions(fight, methodpredictions)
      evaluate_distance_predictions(fight, distancepredictions)
    end
  end

  def evaluate_method_predictions(fight, predictions)
    if fight.result.fighter == fight.red
      fighter = fight.red
      corner = "red"
    elsif fight.result.fighter == fight.blue
      fighter = fight.blue
      corner = "blue"
    else
      corner = nil
    end

    method = fight.result.method

    correct_fighter_predictions = predictions.where(fighter: fighter)
    correct_any_predictions =
      correct_fighter_predictions.where(method: "#{corner}_any")
    correct_method_predictions =
      correct_fighter_predictions.where(method: "#{corner}_#{method}")

    correct_predictions = correct_any_predictions + correct_method_predictions

    score_predictions(correct_predictions, fight.event)
  end

  def evaluate_distance_predictions(fight, predictions)
    if fight.result.method == "decision" || fight.result.method == "draw"
      correct_predictions = predictions.where(distance: true)
    else
      correct_predictions = predictions.where(distance: false)
    end

    score_predictions(correct_predictions, fight.event)
  end

  def score_predictions(correct_predictions, event)
    unless correct_predictions.blank?
      correct_predictions.each do |prediction|
        prediction.update_attribute(:is_correct, true)
        prediction
          .user
          .user_event_budgets
          .find_by(event: event)
          .update_winnings((prediction.wager * prediction.line).round + prediction.wager)
      end
    end
  end

  def void_predictions(fight, event, methodpredictions, distancepredictions)
    unless methodpredictions.blank?
      methodpredictions.each do |methodprediction|
        methodprediction.update_attribute(:is_correct, nil)
        methodprediction
          .user
          .user_event_budgets
          .find_by(event: event)
          .refund(methodprediction.wager)
      end
    end
    unless distancepredictions.blank?
      distancepredictions.each do |distanceprediction|
        distanceprediction.update_attribute(:is_correct, nil)
        distanceprediction
          .user
          .user_event_budgets
          .find_by(event: event)
          .refund(distanceprediction.wager)
      end
    end
  end
end
