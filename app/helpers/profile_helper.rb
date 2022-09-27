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
       prediction_str = ""
      end
      @method_prediction.fighter.name.split()[-1] + prediction_str
    elsif fight.distancepredictions.exists?(user: user)
      @distance_prediction = fight.distancepredictions.find_by(user: user)
      @prediction = @distance_prediction.distance

      if @prediction == true
        prediction_str = "Fight goes to Decision"
      elsif @prediction == false
        prediction_str = "Fight doesn't go to Decision"
      else
        prediction_str = ""
      end
      prediction_str
    else
      ""
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

  def to_win(wager, line)
    wager + (wager * line).round
  end

  def valid(prediction)
    if prediction.event.CONCLUDED?
      if prediction.is_correct == true
        "Win"
      elsif prediction.is_correct == false
        "Loss"
      else
        "NC"
      end
    else
      "-"
    end
  end

  def get_amount(event, amount)
    if event.CONCLUDED?
      "$#{amount}"
    else
      "-"
    end
  end

  def get_net(event, winnings, wagered)
    if event.CONCLUDED?
      "$#{winnings - wagered}"
    else
      "-"
    end
  end

  def get_percent_change(event, winnings, wagered)
    if !event.CONCLUDED?
      "-"
    elsif winnings == 0
      "0%"
    else
    difference = winnings - wagered
    percent = (difference/winnings)*100
    "%#{percent}"
    end
  end
end
