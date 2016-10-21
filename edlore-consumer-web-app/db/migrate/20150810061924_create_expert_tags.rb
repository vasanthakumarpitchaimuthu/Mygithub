class CreateExpertTags < ActiveRecord::Migration
  def change
    create_table :expert_tags do |t|
      t.string :tag_name
      t.integer :user_id
      t.integer :expert_id
      t.timestamps
    end
  end
end
