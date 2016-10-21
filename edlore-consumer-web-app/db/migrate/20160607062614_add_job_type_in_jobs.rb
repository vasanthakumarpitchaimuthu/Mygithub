class AddJobTypeInJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :job_type, :string
  end
end
