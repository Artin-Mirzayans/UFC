class RenameFighterForeignKeys < ActiveRecord::Migration[7.0]
  def change
    rename_column :fights, :red, :red_id
    rename_column :fights, :blue, :blue_id
  end
end