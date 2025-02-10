class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :people, :integer
    add_column :users, :budget, :integer
    add_column :users, :location, :text
    add_column :users, :mood, :text
    add_column :users, :remarks, :text
  end
end
