class OddsController < ApplicationController
    def scrape
        ScrapeOddsJob.perform_later
        head:ok
    end
end