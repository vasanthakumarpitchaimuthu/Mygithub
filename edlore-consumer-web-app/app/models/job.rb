class Job < ActiveRecord::Base
  #Associations
  belongs_to :job	
  belongs_to :user
  belongs_to :expert
  belongs_to :category
  belongs_to :sub_category
  has_many :comments
  has_many :feedbacks
  has_many :jobs
  has_many :report_issues, :dependent=>:destroy
  has_many :purchase_parts
  #Search function
  def self.search(search)
    if search 
     where('issue_name LIKE? or status LIKE? or visit_address LIKE?',"%#{search}","%#{search}%","%#{search}%" )
    else
     all
    end
  end
  #get latest feedback for get job dtails
  def feed_back
    if !self.feedbacks.blank?
     self.feedbacks.last.description
    else
      ''
    end
  end
  #get latest rating for get job dtails
  def job_rating
    if !self.feedbacks.blank?
     self.feedbacks.last.rating
    else
      ''
    end
  end
  #receive date format 
  def receive_date
    if !self.received_date.blank?
      self.received_date.strftime("%m/%d/%Y")
    else
      ''
    end
  end
  #complete date format change
  def complete_date
    if !self.completed_date.blank?
      self.completed_date.strftime("%m/%d/%Y")
    else
      ''
    end
  end
  #get job location
  def job_location
    "#{self.latitude},#{self.longitude}"
  end
  #get category name
  def cat_name
    self.category.category_name
  end
  #get sub category name
  def sub_cat_name
    self.sub_category.sub_cat_name
  end
  #get expert location
  def expert_job_location
    expert = Expert.find_by_id(self.expert_id)
    "#{expert.latitude},#{expert.longitude}"
  end
  #get distance
  def get_distance
    a = Geocoder::Calculations.distance_between([self.latitude,self.longitude], [self.expert.latitude,self.expert.longitude])
    distance = (a * 1.60934).round
    return distance
  end
end
