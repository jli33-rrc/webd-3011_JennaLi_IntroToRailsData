class ReplaceEmailWithUsernameInUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :email, :string
    add_column :users, :username, :string
  end
end
