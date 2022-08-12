# @doc = Nokogiri.HTML(URI.open("ufcodds.html"))
@doc =
  File.open("C:/Users/Artin/Desktop/EDU/UFC/lib/ufcodds.html") do |f|
    Nokogiri.HTML(f)
  end

@events = Event.where(status: "UPCOMING")
oddstables = @doc.css(".table-div")

@events.each do |event|
  oddstable =
    oddstables.find do |current_table|
      current_table.css(".table-header a").text.upcase == event.name
    end

  next if oddstable.nil?

  puts event.name
  oddsrow =
    oddstable
      .css(".table-inner-wrapper")
      .css(".table-scroller")
      .css(".odds-table")
      .css("tbody")
      .css("tr")

  oddsrow.each do |oddsrow|
    straight_line = oddsrow.css("td").css(".but-sg")
    prop_line = oddsrow.css("td").css(".but-sgp")
    row_header = oddsrow.css("th")

    averageodds = 0
    sum = 0
    sign = ""
    fighter_bool = false
    fight = Fight.new
    arr = Array.new(10)

    if row_header.at_css(".t-b-fcc")
      if event.fighters.exists?(name: row_header.text) && straight_line
        fighter = event.fighters.find_by(name: row_header.text)
        fighter_bool = true
        fight = fighter.fights.find_by(event_id: event.id)
        print fighter.name + " Wins by Any: "
        arr = straight_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
        if arr.length() > 2
          sum = 0
          arr.each do |line|
            sign = line[0]
            line.slice!(0)
            line = line.to_f
            if sign == "+"
              line = (line / 100) + 1
            elsif sign == "-"
              line = (100 / line) + 1
            else
              print "What am i looking at? It's not betting odds that's for sure!"
              break
            end
            sum += line
          end
          averageodds = (sum / arr.length).round(2)
          puts averageodds
        else
          puts "Not enough odds for me to care about!"
        end
      else
        fighter_bool = false
        puts "Unknown Fighter. -_-"
      end
      # else
      #   if fighter_bool && prop_line
      #     red_last = fight.red.name.split()[-1]
      #     blue_last = fight.blue.name.split()[-1]

      #     if row_header.text == red_last + " wins by TKO/KO"
      #       print "Fighter ID: " + "#{fight.red.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     elsif row_header.text == red_last + " wins by submission"
      #       print "Fighter ID: " + "#{fight.red.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     elsif row_header.text == red_last + " wins by decision"
      #       print "Fighter ID: " + "#{fight.red.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     elsif row_header.text == blue_last + " wins by TKO/KO"
      #       print "Fighter ID: " + "#{fight.blue.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     elsif row_header.text == blue_last + " wins by submission"
      #       print "Fighter ID: " + "#{fight.blue.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     elsif row_header.text == blue_last + " wins by decision"
      #       print "Fighter ID: " + "#{fight.blue.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     elsif row_header.text == "Fight goes to decision"
      #       print "Fight ID: " + "#{fight.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     elsif row_header.text == "Fight doesn't go to decision"
      #       print "Fight ID: " + "#{fight.id}" + " " + row_header.text
      #       print prop_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
      #       puts ""
      #     else
      #       # We don't care about this prop bet
      #     end
      #   else
      #     # We don't know this fighter for this prop bet OR we don't have any info for this prop bet "
      #   end
    end
  end
end
