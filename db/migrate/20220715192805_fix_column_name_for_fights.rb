class FixColumnNameForFights < ActiveRecord::Migration[7.0]
  def change
    rename_column :fights, :placement, :position
  end
end
