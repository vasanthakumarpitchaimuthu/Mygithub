class AddNewColumnsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :make, :string
    add_column :jobs, :model, :string
  end
end
