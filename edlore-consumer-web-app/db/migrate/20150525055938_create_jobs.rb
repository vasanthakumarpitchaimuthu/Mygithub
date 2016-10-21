class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :issue_name
      t.datetime :received_date
      t.datetime :completed_date
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :user_id
      t.integer :expert_id
      t.string :status
      t.timestamps
    end
  end
end
