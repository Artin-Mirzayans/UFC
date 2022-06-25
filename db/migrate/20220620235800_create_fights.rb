class CreateFights < ActiveRecord::Migration[7.0]
  def change
    create_table :fights do |t|
      t.integer :event_id
      t.string :f1
      t.string :f2
      t.integer :placement
      t.timestamps
    end
  end
end
