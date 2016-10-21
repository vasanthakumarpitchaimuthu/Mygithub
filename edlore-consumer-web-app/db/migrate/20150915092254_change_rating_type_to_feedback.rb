class ChangeRatingTypeToFeedback < ActiveRecord::Migration
  def change
  	change_column :feedbacks, :rating, :integer, :default => 0
  end
end
