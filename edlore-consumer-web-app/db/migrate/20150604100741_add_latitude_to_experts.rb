class AddLatitudeToExperts < ActiveRecord::Migration
  def change
  	add_column :experts, :latitude, :float
  	add_column :experts, :longitude, :float
  end
end
