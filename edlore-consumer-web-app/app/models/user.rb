class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #Notification Send
  #after_create :send_notification
  
  #Associations
   has_one :device_token
   has_many :complaints
   has_many :comments
   has_many :jobs
   has_many :feedbacks, :dependent=>:destroy
   has_many :purchase_parts
   belongs_to :expert
  #validaions
  validates :email, :presence => true, :uniqueness => {:scope => [:user_type]}, :email => true  
  #user search function
  def self.search(search)
    if search 
     where('email LIKE? or username LIKE? or city LIKE?',"%#{search}","%#{search}%","%#{search}%")
    else
     all
    end
  end
end
