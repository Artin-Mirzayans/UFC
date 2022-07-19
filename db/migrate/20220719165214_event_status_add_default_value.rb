class EventStatusAddDefaultValue < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:events, :status, 0)
  end
end
