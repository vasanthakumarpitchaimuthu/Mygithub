class AddStatusToPurchaseParts < ActiveRecord::Migration
  def change
  	add_column :purchase_parts,:status, :string
  end
end
