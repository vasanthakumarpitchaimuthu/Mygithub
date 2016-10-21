class AddCancelledByToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :cancelled_by, :string
  end
end
