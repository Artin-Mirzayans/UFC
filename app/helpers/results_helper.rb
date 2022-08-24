module ResultsHelper
  def disabled(fight)
    if fight.result.new_record?
      return ""
    else
      return "disabled"
    end
  end
end
