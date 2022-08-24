class ChangeFighterIdToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :results, :fighter_id, :integer, using: "fighter_id::integer"
  end
end
