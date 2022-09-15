class AddDatabaseIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :methodpredictions, :user_id
    add_index :distancepredictions, :user_id
    add_index :user_event_budgets, :user_id
  end
end
