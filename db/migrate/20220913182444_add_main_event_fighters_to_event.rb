class AddMainEventFightersToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :apiname, :string
    add_column :events, :red, :string
    add_column :events, :blue, :string
  end
end
