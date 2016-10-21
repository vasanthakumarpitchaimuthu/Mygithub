class AddColumnToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :stripetoken, :string
  end
end
