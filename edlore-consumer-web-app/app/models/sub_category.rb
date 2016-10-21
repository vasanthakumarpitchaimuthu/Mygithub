class SubCategory < ActiveRecord::Base
  #Associations
   belongs_to :category
   has_many :experts
   has_many :jobs
  #valiations
   validates :sub_cat_name, presence: true, :uniqueness => {:scope => [:category_id], :case_sensitive => false}
  #def exp_count
   def exp_count
   	 self.experts.count
   end
end
