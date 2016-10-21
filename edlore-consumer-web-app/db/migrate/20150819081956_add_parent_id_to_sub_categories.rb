class AddParentIdToSubCategories < ActiveRecord::Migration
  def change
  	add_column :sub_categories, :parent_id, :integer
  end
end
