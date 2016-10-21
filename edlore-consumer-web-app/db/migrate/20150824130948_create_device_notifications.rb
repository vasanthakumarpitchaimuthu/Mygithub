class CreateDeviceNotifications < ActiveRecord::Migration
  def change
    create_table :device_notifications do |t|
      t.string :device_id
      t.integer :user_id
      t.timestamps
    end
  end
end
