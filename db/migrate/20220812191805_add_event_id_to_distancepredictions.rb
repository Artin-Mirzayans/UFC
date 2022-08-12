class AddEventIdToDistancepredictions < ActiveRecord::Migration[7.0]
  def change
    add_column :distancepredictions, :event_id, :integer
  end
end
