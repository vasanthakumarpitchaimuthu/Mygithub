class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.string :complaint_title
      t.datetime :received_date
      t.integer :job_id
      t.integer :expert_id
      t.integer :user_id
      t.string :status
      t.text :comments
      t.timestamps
    end
  end
end
