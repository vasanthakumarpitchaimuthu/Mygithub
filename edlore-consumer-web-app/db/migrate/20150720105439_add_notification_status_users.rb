class AddNotificationStatusUsers < ActiveRecord::Migration
  def change
  	add_column :users, :notification_status, :boolean, :default => 1
  	add_column :users, :call_time, :integer, :default => 1
  end
end
