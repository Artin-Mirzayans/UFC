module ProfileHelper
  def bet_option(fight, user)
    if fight.methodpredictions.exists?(user: user)
      @method_prediction = fight.methodpredictions.find_by(user: user)
      @prediction = @method_prediction.method

      if @prediction.include? "any"
        prediction_str = " Wins by Any"
      elsif @prediction.include? "ko"
        prediction_str = " Wins by KO"
      elsif @prediction.include? "sub"
        prediction_str = " Wins by Submission"
      elsif @prediction.include? "dec"
        prediction_str = " Wins by Decision"
      else
        return ""
      end
      return @method_prediction.fighter.name.split()[-1] + prediction_str
    elsif fight.distancepredictions.exists?(user: user)
      @distance_prediction = fight.distancepredictions.find_by(user: user)
      @prediction = @distance_prediction.distance

      if @prediction == true
        prediction_str = "Fight goes to Decision"
      elsif @prediction == false
        prediction_str = "Fight doesn't go to Decision"
      else
        return ""
      end
      return prediction_str
    else
      return ""
    end
  end

  def sort_fights(fights)
    fights
      .reduce({ MAIN: [], PRELIMS: [], EARLY: [] }) do |hash, current_fight|
        hash[current_fight.placement.to_sym].push(current_fight)
        hash
      end
      .transform_values { |fights| fights.sort_by { |fight| fight.position } }
      .values
      .flatten
  end

  def valid(prediction)
    if prediction.event.CONCLUDED?
      if prediction.is_correct == true
        "Correct"
      elsif prediction.is_correct == false
        "Incorrect"
      else
        "NC"
      end
    else
      "-"
    end
  end
end
