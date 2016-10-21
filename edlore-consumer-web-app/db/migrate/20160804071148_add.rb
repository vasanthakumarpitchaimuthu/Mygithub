class Add < ActiveRecord::Migration
  def change
  	add_column :users, :delete_at, :integer, :null => false, :default => 0
  end
end
