class ChangeColumnTypeForCustomer < ActiveRecord::Migration
  def change
  	  	change_column :customers, :pay , :integer

  end
end
