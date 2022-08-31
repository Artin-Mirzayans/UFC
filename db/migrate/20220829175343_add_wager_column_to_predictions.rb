class AddWagerColumnToPredictions < ActiveRecord::Migration[7.0]
  def change
    add_column :methodpredictions, :wager, :integer
    add_column :distancepredictions, :wager, :integer
  end
end
