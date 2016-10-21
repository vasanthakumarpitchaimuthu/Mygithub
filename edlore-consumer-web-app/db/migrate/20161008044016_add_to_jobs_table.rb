class AddToJobsTable < ActiveRecord::Migration
  def change
  	  	add_column :jobs, :payment, :integer

  end
end
