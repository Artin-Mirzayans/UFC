class AddVenueToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :venue, :string
  end
end
