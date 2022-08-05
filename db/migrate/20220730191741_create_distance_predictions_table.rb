class CreateDistancePredictionsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :distancepredictions do |t|
      t.integer :user_id
      t.integer :fight_id
      t.boolean :distance
      t.float :line
      t.timestamps
    end
  end
end
