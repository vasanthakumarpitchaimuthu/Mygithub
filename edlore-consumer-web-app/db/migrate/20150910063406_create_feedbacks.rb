class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :description
      t.integer :rating
      t.integer :job_id
      t.integer :expert_id
      t.integer :user_id
      t.timestamps
    end
  end
end
