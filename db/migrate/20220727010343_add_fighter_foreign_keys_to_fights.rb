class AddFighterForeignKeysToFights < ActiveRecord::Migration[7.0]
  def change
    change_column :fights, :red, :integer, using: 'red::integer'
    change_column :fights, :blue, :integer, using: 'blue::integer'
  end
end
