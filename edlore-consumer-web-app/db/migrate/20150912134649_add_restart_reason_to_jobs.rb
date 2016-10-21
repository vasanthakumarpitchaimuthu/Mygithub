class AddRestartReasonToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :restart_reason, :string
  end
end
