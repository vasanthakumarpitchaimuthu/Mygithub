class Expert < ActiveRecord::Base
  #Associtations  
  has_many :jobs
  has_many :complaints, :dependent=>:destroy
  has_many :feedbacks, :dependent=>:destroy
  has_many :comments, :dependent=>:destroy
  has_many :expert_tags, :dependent=>:destroy
  has_many :purchase_parts
  belongs_to :category
  belongs_to :sub_category
  belongs_to :user
  has_one :user, :dependent=>:destroy, :foreign_key => :expert_id
  
  
  #geocode get latitude and lang
  geocoded_by :zipcode, :on => :create
  after_validation :geocode, :on => :create
  #validations
  validates :first_name, presence:  { :message => "can't be blank" }
  validates :last_name, presence:  { :message => "can't be blank" }
  validates :email, :presence => true, :uniqueness => true, :email => true  
  validates :phone, :numericality => { only_integer: true }, :length => { :minimum => 10, :maximum => 15 }              
  validates :city, presence:  { :message => "can't be blank" } 
  validates :zipcode, presence: {:message => "can't be blank"}
  validates :state, presence:  { :message => "can't be blank" }
  # validates :zipcode, presence:  { :message => "can't be blank" }
  # validates_as_postal_code :zipcode, :country => "CA", :allow_blank => true
  validates :category_id, presence:  { :message => "Select Category" }
  validates :sub_category_id, presence:  { :message => "Select Subcategory" }

  #Search function for experts
   def self.search(search)
    if search 
     where('first_name LIKE? or last_name LIKE? or city LIKE? or email LIKE?',"%#{search}","%#{search}%","%#{search}%","%#{search}%")
    else
     all
    end
  end
  #Comp
  def job_count
   self.jobs.where(:status => "completed").count
  end
  #get job location
  def expert_location
   "#{self.latitude},#{self.longitude}"
  end
  #get total ratings
  def total_rating
    self.feedbacks.sum(:rating)
  end
  #get average ratings
  def avg_rating
   if self.feedbacks.sum(:rating) != 0 and self.feedbacks.count != 0
    self.feedbacks.sum(:rating) / self.feedbacks.count 
   else
    0
   end
  end
  #get expert user id
  def expert_user_id
    self.user.id
  end
  #expert_device_token
  def expert_device_token
    if !self.user.device_token.blank?
      self.user.device_token.device_token
    else
      'null'
    end
    #return token
  end
  #get job disance
  def job_distance
    
  end
end
