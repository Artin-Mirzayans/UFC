class LockCardJob < ApplicationJob
  queue_as :default
  def perform(event_id, card)
    @event = Event.find(event_id)
    @event.INPROGRESS! if @event.UPCOMING?
    lock_fights(@event.id, card)
  end

  def lock_fights(event_id, card)
    @event = Event.find(event_id)
    @fights =
      @event.fights.where(placement: card).order(:position).reverse_order
    count = 1
    @fights.each do |fight|
      LockFightJob.set(wait: (15 * count).seconds).perform_later(fight.id)
      count += 1
    end
  end
end
