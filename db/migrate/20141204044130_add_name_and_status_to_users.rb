class AddNameAndStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :status, :string
  end
end