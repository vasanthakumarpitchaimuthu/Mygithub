class CreatePurchaseParts < ActiveRecord::Migration
  def change
    create_table :purchase_parts do |t|
      t.string :part_name
      t.integer :job_id
      t.integer :user_id
      t.integer :expert_id

      t.timestamps
    end
  end
end
