class CreateExperts < ActiveRecord::Migration
  def change
    create_table :experts do |t|
      t.string :expert_id
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :city
      t.string :state
      t.string :country
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :expert_user_id
      t.timestamps
    end
  end
end
