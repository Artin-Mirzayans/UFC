class AddWageredColumnToBudgets < ActiveRecord::Migration[7.0]
  def change
    add_column :user_event_budgets, :wagered, :integer, default: 0
  end
end
