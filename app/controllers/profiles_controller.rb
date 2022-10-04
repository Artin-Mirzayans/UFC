class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @event_ids =
      UserEventBudget
        .where(user: @user)
        .where.not(wagered: 0)
        .distinct
        .pluck(:event_id)
    @pagy, @events = pagy(Event.where(id: @event_ids).order(date: :desc), items: 5)
  end

  def search
    if User.exists?(username: search_params[:username])
      @user = User.find_by(username: search_params[:username])
      @event_ids =
      UserEventBudget
        .where(user: @user)
        .where.not(wagered: 0)
        .distinct
        .pluck(:event_id)
        @pagy, @events = pagy(Event.where(id: @event_ids).order(date: :desc), items: 5)
        @render = true
        respond_to { |format| format.turbo_stream }
    else
      respond_to { |format| format.turbo_stream { flash.now[:notice] = "User Not Found" } }
    end
  end

  private
  def search_params
    params.require(:user).permit(:username)
  end

end
