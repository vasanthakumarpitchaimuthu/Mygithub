class AddInputTypeToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :input_type, :integer
  end
end
