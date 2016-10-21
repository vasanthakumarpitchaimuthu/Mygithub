class CreateManuals < ActiveRecord::Migration
  def change
    create_table :manuals do |t|
      t.integer :sub_category_id
      t.string :document_file_name
      t.string :document_content_type
      t.integer :document_file_size
      t.timestamp :document_updated_at
      t.string :download_url
      t.string :download_title
      t.timestamps null: false
      t.timestamps
    end
  end
end
