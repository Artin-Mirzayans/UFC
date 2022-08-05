class RenamePredictionsTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :predictions, :methodpredictions
  end
end
