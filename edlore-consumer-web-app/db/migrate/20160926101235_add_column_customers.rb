class AddColumnCustomers < ActiveRecord::Migration
  def change
  	    add_column :customers, :user_id, :integer
  	    add_column :customers, :stripetoken, :string


  end
end