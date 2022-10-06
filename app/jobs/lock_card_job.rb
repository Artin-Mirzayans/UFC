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
      if fight == @fights.first
        LockFightJob.set(wait: 13.minutes).perform_later(fight.id)
      end
      LockFightJob.set(wait: (19 * count).minutes).perform_later(fight.id)
      count += 1
    end
  end
end
