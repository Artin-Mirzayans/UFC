class RenameOddsColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :odds, :red_ko, :red_knockout
    rename_column :odds, :red_sub, :red_submission
    rename_column :odds, :red_dec, :red_decision
    rename_column :odds, :blue_ko, :blue_knockout
    rename_column :odds, :blue_sub, :blue_submission
    rename_column :odds, :blue_dec, :blue_decision
  end
end
