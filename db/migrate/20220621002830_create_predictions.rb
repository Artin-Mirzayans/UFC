class CreatePredictions < ActiveRecord::Migration[7.0]
  def change
    create_table :predictions do |t|
      t.integer :fight_id
      t.integer :user_id
      t.integer :fighter
      t.integer :method
      t.float :line
      t.timestamps
    end
  end
end
