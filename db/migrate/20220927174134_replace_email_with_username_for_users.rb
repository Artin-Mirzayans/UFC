class ReplaceEmailWithUsernameForUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :email, :string
    add_column :users, :username, :string, null: false, default: ""
    add_index :users, :username, unique: true
  end
  
end
