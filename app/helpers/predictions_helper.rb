module PredictionsHelper

def predictions_open?(
    red_prediction,
    distance_prediction,
    blue_prediction,
    fight
  )
    !fight.locked? && !fight.event.CONCLUDED? && red_prediction.update_timer? &&
      distance_prediction.update_timer? && blue_prediction.update_timer?
  end

  def method_is_selected?(prediction, method)
    !prediction.new_record? && prediction.method == method
  end

  def distance_is_selected?(prediction, method)
    !prediction.new_record? && prediction.distance == method
  end
  
  def winning_any?(event, result, fighter)
    event.CONCLUDED? && fighter == result.fighter
  end

  def winning_method?(event, result, fighter, method)
    event.CONCLUDED? && fighter == result.fighter && method == result.method
  end

  def winning_distance?(event, result, distance)
    if distance == true
        event.CONCLUDED? && result.method == 'decision' || result.method =='draw'
    elsif distance == false
        event.CONCLUDED? && result.method != 'decision' && result.method != 'draw'
    end
  end

  def get_wager(prediction)
    if !prediction.wager.nil?
      prediction.wager
    else
      0
    end
  end

end