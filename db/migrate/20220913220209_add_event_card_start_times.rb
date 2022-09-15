class AddEventCardStartTimes < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :main, :time
    add_column :events, :prelims, :time
    add_column :events, :early, :time
  end
end
