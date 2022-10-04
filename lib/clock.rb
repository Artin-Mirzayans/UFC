Dir["./jobs/*.rb"].each { |file| require file }

require "clockwork"
require "./config/boot"
require "./config/environment"

module Clockwork
  handler do |job, time|
    puts "Running #{job}, at #{time}"
    #send("#{job}")
    #puts "#{job}".constantize
  end

  # every(10.seconds, "event.upcoming") do
  #   @event = ::Event.get_upcoming_event
  #   if @event
  #     puts "Name " + @event.apiname
  #     puts "Category " + @event.category
  #   end
  #   EventStartJob.perform_later(@event.id) if @event && @event.started?
  # end

  every(2.hour, "scrape.odds.job") do
    ScrapeOddsJob.perform_later
  end
end
