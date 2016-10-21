class Complaint < ActiveRecord::Base
  
  #Association
  belongs_to :user
  belongs_to :expert
end
