@doc = Nokogiri::HTML(URI.open('https://www.bestfightodds.com/'))

@events = Event.where(status: "UPCOMING")
tables = @doc.css('.table-div')

@events.each do |event|
    table = tables.find { |current_table| current_table.css('.table-header a').text.upcase == event.name }

    next if table.nil?

        puts event.name
        oddstable = table.css('.table-inner-wrapper').css('.table-scroller').css('.odds-table').css('tbody').css('tr')
        oddstable.each do |oddstable|
        if event.reds.exists?(name: oddstable.css('.t-b-fcc').text) || event.blues.exists?(name: oddstable.css('.t-b-fcc').text)
            puts oddstable.css('.t-b-fcc').text + oddstable.css('td').css('span').text
        end
    end
end
