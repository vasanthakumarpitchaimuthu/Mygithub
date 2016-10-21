class CreateExpertNotifications < ActiveRecord::Migration
  def change
    create_table :expert_notifications do |t|
    	t.string :expert_id
    	t.integer :job_id

      t.timestamps
    end
  end
end
