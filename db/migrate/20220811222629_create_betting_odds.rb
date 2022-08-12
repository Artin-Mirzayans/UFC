class CreateBettingOdds < ActiveRecord::Migration[7.0]
  def change
    create_table :odds do |t|
      t.integer :fight_id
      t.float :red_any
      t.float :red_ko
      t.float :red_sub
      t.float :red_dec
      t.float :blue_any
      t.float :blue_ko
      t.float :blue_sub
      t.float :blue_dec
      t.float :yes_decision
      t.float :no_decision
      t.timestamps
    end
  end
end
