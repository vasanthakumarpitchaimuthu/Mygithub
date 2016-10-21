class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :description
      t.integer :user_id
      t.integer :expert_id
      t.integer :job_id
      t.timestamps
    end
  end
end
