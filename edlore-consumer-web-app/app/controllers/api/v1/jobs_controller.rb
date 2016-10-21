=begin
  Jobs Api Controller for mobile json
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class Api::V1::JobsController < ApplicationController
 #before_action :set_job_tag, only: [:show, :edit, :update, :destroy]
 #before filter for check the token verification
 skip_before_filter :verify_authenticity_token
  
  #get nearest expert list 
  def get_experts_list
    if !params[:sub_cat_id].blank? 
      @cat = params[:cat_id]
      @sub_cat = params[:sub_cat_id]
    elsif params[:sub_cat_id].blank?
      text = params[:make].downcase.split(',')
      text.each do|word|
        @expert_tag = ExpertTag.all
        @expert_tag.each do|exp|
          if exp.tag_name.include?(word)
            @cat = exp.expert.category
            @sub_cat = exp.expert.sub_category
          end
        end
      end
    end
    if !@cat.nil? && !@sub_cat.nil?
      lat = params[:lat].to_f
      lan = params[:lng].to_f
      @expert = Expert.near([lat, lan], 1000).where(:category_id => @cat, :sub_category_id => @sub_cat, :expert_mode => 1)
      @all_experts = []
      @expert.each do|exp|
        distance = (exp.distance_from([lat, lan]) * 1.60934)
        @all_experts << {:expert_id => exp.id, :expert_name => exp.first_name, :rating => exp.avg_rating,
                      :total_ratings => exp.total_rating, :job_completed => exp.job_count, :distance => distance.to_i, :minutes => 30,
                      :cat_id => exp.category_id, :sub_cat => exp.sub_category_id,
                      :expert_location => exp.expert_location}
      end
    end 
  end

  def experts_call_list
    word = params[:search]
    text = word.downcase.split(',')
    text.each do|word|
      @tags = ExpertTag.where("tag_name LIKE ?", "%#{word}%") 
        @tags.each do |tag|
          @experts = Expert.where(:id => tag.expert_id, :expert_mode => 1)
        end
      
    end
    location = params[:location]
    @all_experts = []
    @experts = Expert.where(:expert_mode => 1)
    @experts.each do |expert|
     a = Geocoder::Calculations.distance_between(location, expert.expert_location)
     dis = a.to_i
     @all_experts << {:id => expert.id, :expert_id => expert.expert_id, :first_name => expert.first_name, 
                      :avg_rating => expert.avg_rating, :expert_user_id => expert.expert_user_id,
                      :expert_device_token => expert.expert_device_token, :distance => dis}
    end
  end
  
 #check the user have stripe_token or not
  def check_stripe_token       
             @usrr = User.find(params[:consumer_id])
             puts"===@usrr===#{@usrr}======="
           if !@usrr.stripetoken.blank?
                    
              render :json=> {:success => true}, :status=>200
            else
              
              render :json=> {:success => false}, :status=>500
           end

  end
  def create
   @token_user = params[:user_id].split(/\W+/).drop(1)   
   token = DeviceToken.find_by_user_id(@token_user)
    
   if !token.blank?
    job = Job.create(:issue_name => params[:issue_name], :received_date => Time.now, :category_id => params[:cat_id], :sub_category_id => params[:sub_cat_id],
                     :user_id => params[:consumer_id], :input_type => params[:input_type], :make => params[:make], :visit_address => params[:address],
                     :status => "new", :current_status => "new", :latitude => params[:lat], :longitude => params[:lng], :job_type => "call")
     @token_user.each do |user_values|
      token = DeviceToken.find_by_user_id(user_values)
      
    pusher = Grocer.pusher(
      certificate: "#{Rails.root}/public/expert.pem",      
      passphrase:  "Sybrant123",                       
      gateway:     "gateway.sandbox.push.apple.com", 
      port:        2195,                     
      retries:     3                         
    )
    # Environment variables are automatically read, or can be overridden by any specified options. You can also
    notification = Grocer::Notification.new(
      device_token: token.device_token,
      alert:             "New Job Call Confirmation",
      badge:        0,

      custom: {"issue" => params[:issue_name], "job_id" => job.id, "type" => "consumer_call", "consumer_name" => job.user.username }
    )

    pusher.push(notification) # return value is the number of bytes sent successfully
     
   end
   render :json=> {:success => true, :job_id => job.id }, :status=>200
    else 
     render :json=> {:success => false, :message => "something went wrong"}, :status=> 500
    end 
end


  #get particular consumer job details 
  def consumer_job_details
    user = User.find_by_id(params[:user_id])
    if params[:type] == "active"
     @jobs = user.jobs.where.not(status: "completed", expert_id: nil).where(:job_type => nil).order("created_at DESC")
    else
     @jobs = user.jobs.where(:status => "completed", :job_type => nil).order("updated_at DESC")
    end
  end
  #Raise issue about jobs(consumer & experts)
  def report_issue
    if ReportIssue.create(:description => params[:description], :job_id => params[:job_id],
                          :report_by => params[:report_by])
     render :json=> {:success => true}, :status=>200
    else
     render :json=> {:success => false}, :status=>204
    end
  end

  def send_invoice_mail
    job = Job.find_by_id(params[:job_id])
    user = User.find_by_id(params[:user_id])
    UserMailer.invoice_mail(user,job).deliver
  end

end
