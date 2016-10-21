class Feedback < ActiveRecord::Base
  #Association other models	
  belongs_to :job
  belongs_to :user
  belongs_to :expert
end
