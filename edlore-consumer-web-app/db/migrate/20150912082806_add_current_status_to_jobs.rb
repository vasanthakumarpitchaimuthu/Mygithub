class AddCurrentStatusToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :current_status, :string
  end
end
