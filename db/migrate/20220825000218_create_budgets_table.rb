class CreateBudgetsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :user_event_budgets do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :budget
      t.timestamps
    end
  end
end
