class AddFightPlacementColumnToFights < ActiveRecord::Migration[7.0]
  def change
    add_column :fights, :placement, :integer
  end
end
