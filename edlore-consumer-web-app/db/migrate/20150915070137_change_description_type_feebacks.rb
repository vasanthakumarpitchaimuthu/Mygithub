class ChangeDescriptionTypeFeebacks < ActiveRecord::Migration
  def change
  	change_column :feedbacks, :description , :text
  end
end
