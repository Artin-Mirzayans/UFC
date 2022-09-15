class LockFightJob < ApplicationJob
  def perform(fight_id)
    @fight = Fight.find(fight_id)
    @fight.update(locked: true)
  end
end
