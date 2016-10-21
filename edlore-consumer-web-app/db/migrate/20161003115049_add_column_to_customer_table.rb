class AddColumnToCustomerTable < ActiveRecord::Migration
  def change
  	add_column :customers, :pay, :boolean

  end
end
