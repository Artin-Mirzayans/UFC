module EventHelper
  def predictions_open?(
    red_prediction,
    distance_prediction,
    blue_prediction,
    event
  )
    event.status == "UPCOMING" && red_prediction.update_timer? &&
      distance_prediction.update_timer? && blue_prediction.update_timer?
  end

  def method_is_selected?(prediction, method)
    !prediction.new_record? && prediction.method == method
  end

  def distance_is_selected?(prediction, method)
    !prediction.new_record? && prediction.distance == method
  end

  def get_wager(prediction)
    if !prediction.wager.nil?
      return prediction.wager
    else
      return 0
    end
  end

  def in_progress?(event)
    event.status == "INPROGRESS"
  end
end
