class AddPriceInPurchaseParts < ActiveRecord::Migration
  def change
  	add_column :purchase_parts, :price, :float
  	add_column :purchase_parts, :total_amount, :float
  	add_column :purchase_parts, :product_image, :text
  	add_column :purchase_parts, :quantity, :integer
  end
end
