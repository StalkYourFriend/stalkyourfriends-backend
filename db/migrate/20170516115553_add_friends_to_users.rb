class AddFriendsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :friends, :bigint, array: true
  end
end
