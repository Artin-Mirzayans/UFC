class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @event_ids =
      UserEventBudget
        .where(user: @user)
        .where.not(wagered: 0)
        .distinct
        .pluck(:event_id)
    @pagy, @events = pagy(Event.where(id: @event_ids).order(date: :desc), items: 2)
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
      @events = Event.where(id: @event_ids).sort
      render :show
    else
      head:ok
    end
  end

  def search_params
    params.require(:user).permit(:username)
  end

end
