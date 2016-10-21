class CreateConsumerManuals < ActiveRecord::Migration
  def change
    create_table :consumer_manuals do |t|
      t.integer :user_id
      t.integer :consumer_id
      t.integer :manual_id
      t.timestamps
    end
  end
end
