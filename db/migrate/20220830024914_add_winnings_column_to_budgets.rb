class AddWinningsColumnToBudgets < ActiveRecord::Migration[7.0]
  def change
    add_column :user_event_budgets, :winnings, :integer, default: 0
  end
end
