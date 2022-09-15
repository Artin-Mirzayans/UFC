class AddStatusToFights < ActiveRecord::Migration[7.0]
  def change
    add_column :fights, :locked, :boolean, default: false
  end
end
