class AddEventAssociationToPredictions < ActiveRecord::Migration[7.0]
  def change
    add_column :methodpredictions, :event_id, :integer
  end
end
