class RenameFighterColumnInPredictions < ActiveRecord::Migration[7.0]
  def change
    rename_column :predictions, :fighter, :fighter_id
  end
end
