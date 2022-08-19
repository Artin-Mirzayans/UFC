module OddsHelper
  def to_american(decimal)
    if decimal.nil?
      return "N/A"
    else
      if decimal >= 2
        "+#{((decimal - 1) * 100).to_i.to_s}"
      else
        (-100 / (decimal - 1)).to_i.to_s
      end
    end
  end
end
