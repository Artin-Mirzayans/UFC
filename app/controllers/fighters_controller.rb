class FightersController < ApplicationController
  before_action :authorize_admin_or_mod!

  def search
    if params[:name].present?
      @fighters = Fighter.where("name ilike ?", "%#{params[:name]}%").limit(10)
    end

    @search_results_target = "search_results_#{params[:corner]}"

    respond_to { |format| format.turbo_stream }
  end
end
