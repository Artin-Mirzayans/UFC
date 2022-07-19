class ChangeEventStatusColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :events, :status, :integer, using: 'status::integer'
  end
end
