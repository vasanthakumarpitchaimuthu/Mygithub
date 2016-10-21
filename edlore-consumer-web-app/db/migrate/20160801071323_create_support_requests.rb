class CreateSupportRequests < ActiveRecord::Migration
  def change
    create_table :support_requests do |t|
      t.integer :user_id
      t.string :issue_description
      t.integer :type
      t.timestamps
    end
  end
end
