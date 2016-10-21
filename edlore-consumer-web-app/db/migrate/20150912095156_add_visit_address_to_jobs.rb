class AddVisitAddressToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :visit_address, :text
  end
end
