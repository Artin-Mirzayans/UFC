module OddsHelper
  def to_american(decimal)
    if decimal.nil?
      return "N/A"
    else
      if decimal >= 1
        "+#{(decimal * 100).to_i.to_s}"
      else
        (-100 / decimal).to_i.to_s
      end
    end
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
end
