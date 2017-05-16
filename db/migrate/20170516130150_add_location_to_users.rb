class AddLocationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :location, :text
    add_column :users, :icon, :text
    add_column :users, :online, :boolean
  end
end
