class AddFightsRelationToResults < ActiveRecord::Migration[7.0]
  def change
    rename_column :results, :event_id, :fight_id
    rename_column :results, :winner, :fighter_id
    change_column :results, :method, :integer, using: "method::integer"
  end
end
