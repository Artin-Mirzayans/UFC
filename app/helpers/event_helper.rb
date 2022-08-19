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

  def in_progress?(event)
    event.status == "INPROGRESS"
  end
end
