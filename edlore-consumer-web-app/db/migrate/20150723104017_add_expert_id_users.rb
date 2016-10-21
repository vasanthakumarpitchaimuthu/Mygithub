class AddExpertIdUsers < ActiveRecord::Migration
  def change
  	add_column :users, :expert_id, :integer
  end
end
