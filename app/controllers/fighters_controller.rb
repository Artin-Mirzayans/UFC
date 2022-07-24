class FightersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorize_admin_or_mod!

    def search
        if params[:name].present?
          @fighters = Fighter.where("name ilike ?", "%#{params[:name]}%").limit(10)
        end

        @search_results_target = "search_results_#{params[:corner]}"
    
        respond_to do |format|
            format.turbo_stream
        end
    end
end
