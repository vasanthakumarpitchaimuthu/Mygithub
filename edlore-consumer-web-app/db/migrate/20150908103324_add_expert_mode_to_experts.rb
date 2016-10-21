class AddExpertModeToExperts < ActiveRecord::Migration
  def change
  	add_column :experts, :expert_mode, :integer, :default => 1
  end
end
