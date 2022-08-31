class AddIsCorrectColumnToPredictions < ActiveRecord::Migration[7.0]
  def change
    add_column :methodpredictions, :is_correct, :boolean, default: false
    add_column :distancepredictions, :is_correct, :boolean, default: false
  end
end
