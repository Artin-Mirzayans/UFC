class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @event_ids =
      UserEventBudget
        .where(user: @user)
        .where.not(wagered: 0)
        .distinct
        .pluck(:event_id)
    @events = Event.where(id: @event_ids).sort
  end
end
