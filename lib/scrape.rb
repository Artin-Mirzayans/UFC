class Scrape
  def initialize
    # @doc = Nokogiri.HTML(URI.open("https://www.bestfightodds.com/"))
    @doc =
      File.open(
        "C:/Users/Artin/Desktop/EDU/UFC/lib/odds_site/ufcodds.html"
      ) { |f| Nokogiri.HTML(f) }
  end

  def get_tables
    @events = Event.where(status: "UPCOMING")
    all_tables = @doc.css(".table-div")
    tables =
      all_tables.select do |table|
        @events.where(name: table.css(".table-header a").text.upcase).exists?
      end
    return tables
  end

  def update_event(table)
    puts table.css(".table-header a").text.upcase
    oddsrow =
      table
        .css(".table-inner-wrapper")
        .css(".table-scroller")
        .css(".odds-table")
        .css("tbody")
        .css("tr")
    event = Event.find_by(name: table.css(".table-header a").text.upcase)
    fighter = Fighter.new
    fight = Fight.new
    fighter_bool = false

    oddsrow.each do |oddsrow|
      straight_line = oddsrow.css("td").css(".but-sg")
      prop_line = oddsrow.css("td").css(".but-sgp")
      row_header = oddsrow.css("th")

      averageodds = 0
      sum = 0
      sign = ""
      arr = Array.new(10)

      # fighter_any row
      if row_header.at_css(".t-b-fcc")
        if event.fighters.exists?(name: row_header.text) && straight_line
          fighter = event.fighters.find_by(name: row_header.text)
          fighter_bool = true
          fight = fighter.fights.find_by(event: event)

          if fight.red == fighter
            corner = "red"
          else
            corner = "blue"
          end
          odds = fetch_line(straight_line, row_header)
          post_line(fight, "#{corner}_any", odds) if odds.between?(0, 100)
        else
          fighter_bool = false
          puts "Unknown Fighter. -_-"
        end
      else
        if fighter_bool && prop_line
          red_last = fight.red.name.split()[-1]
          blue_last = fight.blue.name.split()[-1]

          odds = -1

          if row_header.text == red_last + " wins by TKO/KO"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "red_knockout", odds) if odds.between?(0, 100)
          elsif row_header.text == red_last + " wins by submission"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "red_submission", odds) if odds.between?(0, 100)
          elsif row_header.text == red_last + " wins by decision"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "red_decision", odds) if odds.between?(0, 100)
          elsif row_header.text == blue_last + " wins by TKO/KO"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "blue_knockout", odds) if odds.between?(0, 100)
          elsif row_header.text == blue_last + " wins by submission"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "blue_submission", odds) if odds.between?(0, 100)
          elsif row_header.text == blue_last + " wins by decision"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "blue_decision", odds) if odds.between?(0, 100)
          elsif row_header.text == "Fight goes to decision"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "yes_decision", odds) if odds.between?(0, 100)
          elsif row_header.text == "Fight doesn't go to decision"
            odds = fetch_line(prop_line, row_header)
            post_line(fight, "no_decision", odds) if odds.between?(0, 100)
          else
            # We don't care about this prop bet
          end
        end # fighter_bool/prop_line
      end #fighter/prop exists
    end #each_row
  end #function

  def fetch_line(betting_line, header)
    print header.text + ": "
    arr = betting_line.map { |line| line.text.gsub(/[^0-9A-Za-z+-]/, "") }
    if arr.length() > 2
      sum = 0
      arr.each do |line|
        sign = line[0]
        line.slice!(0)
        line = line.to_f
        if sign == "+"
          line = line / 100
        elsif sign == "-"
          line = 100 / line
        else
          puts "What am i looking at? It's not betting odds!"
        end
        sum += line
      end
      averageodds = (sum / arr.length).round(2)
      puts averageodds
      return averageodds
    else
      puts "Not enough odds for me to care about!"
      return -1
    end
  end

  def post_line(fight, bet, odds)
    fight.odd.update("#{bet}": odds)
  end
end
#class

scrape = Scrape.new
tables = scrape.get_tables

tables.each { |table| scrape.update_event(table) }
