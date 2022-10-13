class AddBudgetToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :budget, :integer
  end
end
