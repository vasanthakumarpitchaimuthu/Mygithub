class AddAddressToExperts < ActiveRecord::Migration
  def change
  	add_column :experts, :address, :string
  end
end
