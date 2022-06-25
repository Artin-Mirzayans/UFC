class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.integer :event_id
      t.string :winner
      t.string :method
      t.timestamps
    end
  end
end
