class ExpertTag < ActiveRecord::Base
  #Association with other models
  belongs_to :expert
end
