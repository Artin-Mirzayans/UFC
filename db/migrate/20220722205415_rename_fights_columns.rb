class RenameFightsColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :fights, :f1, :red
    rename_column :fights, :f2, :blue
  end
end
