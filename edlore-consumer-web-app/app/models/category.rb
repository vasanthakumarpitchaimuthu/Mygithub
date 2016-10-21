class Category < ActiveRecord::Base
  
  #Associations
  has_many :jobs
  has_many :experts
  has_many :sub_categories, dependent: :destroy
  
  #Validatios
  validates :category_name, presence: true, :uniqueness => {:case_sensitive => false }
  # For nested form tag 
  accepts_nested_attributes_for :sub_categories
  #get number of experts
  def expert_count
  	self.experts.count
  end
end
