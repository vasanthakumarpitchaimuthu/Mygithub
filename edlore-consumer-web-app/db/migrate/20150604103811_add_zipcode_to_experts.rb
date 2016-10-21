class AddZipcodeToExperts < ActiveRecord::Migration
  def change
   add_column :experts, :zipcode, :string
  end
end
