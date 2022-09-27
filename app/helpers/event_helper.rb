module EventHelper
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

  def method_wagered_or_live_odds(prediction, method, liveodds, fight)
    if method_is_selected?(prediction, method)
      to_american(prediction.line)
    else
      liveodds
    end
  end

  def distance_wagered_or_live_odds(prediction, method, liveodds, fight)
    if distance_is_selected?(prediction, method)
      to_american(prediction.line)
    else
      liveodds
    end
  end

  def get_method_wagered_odds(prediction, method)
    if method_is_selected?(prediction, method)
      to_american(prediction.line)
    else
      "N/A"
    end
  end

  def get_distance_wagered_odds(prediction, method)
    if distance_is_selected?(prediction, method)
      to_american(prediction.line)
    else
      "N/A"
    end
  end

  def get_wager(prediction)
    if !prediction.wager.nil?
      prediction.wager
    else
      0
    end
  end

  def start_time(time)
    if time.present?
      time.strftime("%l:%M %p (PST)")
    else 
    "TBD"
    end
  end

  def get_red_image_or_default(event)
    if event.red_image.present?
      event.red_image
    else
      "default_fighter.png"
    end
  end

  def get_blue_image_or_default(event)
    if event.blue_image.present?
      event.blue_image
    else
      "default_fighter.png"
    end
  end
end
