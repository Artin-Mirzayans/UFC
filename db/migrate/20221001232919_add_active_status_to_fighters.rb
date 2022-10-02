class AddActiveStatusToFighters < ActiveRecord::Migration[7.0]
  def change
    add_column :fighters, :active, :boolean, default: true
  end
end
