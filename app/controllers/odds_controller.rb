class OddsController < ApplicationController
  before_action :authorize_admin_or_mod!
    def scrape
        ScrapeOddsJob.perform_later
        head:ok
    end
end