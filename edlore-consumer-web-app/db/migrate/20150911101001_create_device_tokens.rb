class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.string :device_token
      t.integer :user_id
      t.timestamps
    end
  end
end
