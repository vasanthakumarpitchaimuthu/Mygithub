=begin
  Experts Api Controller for mobile json
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class Api::V1::ExpertsController < ApplicationController
 #before filter for check the token verification 
 skip_before_filter :verify_authenticity_token

 #getting requsted jod details
  def get_job_details
    @@lat_param = params[:lat] 
    @@lon_param = params[:lon]
    puts"----------#{@@lat_param}-----------"
        puts"----------#{@@lon_param}-----------"


    @splited = []
    job = Job.find_by_id(params[:job_id])
    if !job.blank?
      render :json=> {:success => true, :job_id => job.id, :issue_name => job.issue_name, 
                      :consumer_name => job.user.username, :consumer_phone => job.user.phone,
                      :staus => job.status, :current_status => job.current_status, :address =>job.visit_address,
                      :time => 123, :distance => 40, :input_type => job.input_type, :comp_date => job.complete_date,
                      :visit_time => 20, :call_time => 30, :bill => 30, :paid => 500, :feed_back => job.feed_back, :rating => job.job_rating,
                      :consumer_location => job.job_location}, :status=>200


    #send help accept notification to Consumer
    if params[:accept]
     job.update_attributes(:expert_id =>  params[:expert_id])
     pusher = Grocer.pusher(
        certificate: "#{Rails.root}/public/consumer.pem",      
        passphrase:  "Sybrant123",                       
        gateway:     "gateway.sandbox.push.apple.com", 
        port:        2195,                     
        retries:     3                         
      )
      # Environment variables are automatically read, or can be overridden by any specified options. You can also
      notification = Grocer::Notification.new(
        device_token: job.user.device_token.device_token,
        alert:             alert,
        badge:        0,
        custom: { "job" => job.id, "type" => "expert_accept_the_request", "latitute" => @@lat_param, "longitude" => @@lon_param }
      )

      pusher.push(notification)

    end
    ex = Expert.find(job.expert_id)
    e = ExpertNotification.find_by_job_id(params[:job_id]) 
    expert = e.expert_id.gsub(/[':;]/, " ") 
     @users = expert.split(",")    
     @del_users = @users - ["#{ex.user.id}"]
     @del_users.each do |user| 
       token = DeviceToken.find_by_user_id(user)      
        if !token.blank? 
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
        alert:             alert, 
        badge:        0, 
        custom: { "job" => job.id, "expert" => expert, "type" => "expert_has_been_accepted"  } 
      ) 

      pusher.push(notification) 
    #end 
       else 

      end 
    end 
     else 
      render :json=> {:success => false}, :status=>204 
    end 
  end
  #get expert job history
  def expert_job_details
    expert = Expert.find_by_id(params[:expert_id])
    if params[:type] == "active"
     @jobs = expert.jobs.where.not(status: "completed").where(:job_type => nil).order("created_at DESC")
    else
     @jobs = expert.jobs.where(:status => "completed", :job_type => nil).order("updated_at DESC")
    end
  end
  #expert review consumers feedbacks
  def review_feedback
    @reviews = Feedback.where(:expert_id => params[:expert_id]).order("id DESC")
    @review_list = []
      @reviews.each do |review|
        @review_list << {:consumer_id => review.user_id, :consumer_name=> review.user.username,
                         :exp_id => review.expert_id, :exp_name => review.expert.first_name,
                         :job_id => review.job_id, :issue_name => review.job.issue_name,
                         :rating => review.rating, :feedback => review.description, :comp_date => review.job.complete_date, 
                         :status => review.job.status, :current_status => review.job.current_status}
      end 
  end
  #send notifications expert to consumers
   def expert_to_consumer_notifications
 

    job = Job.find(params[:job_id])
    if job.status == "cancelled"
      render :json=> {:success => false, :message => "Consumer cancelled"}
    # elsif !job.expert_id.nil? and !job.expert_id.blank?
    #   render :json=> {:success => false, :message => "The help already assigned"}
    else
      if params[:start]
        type = "expert_started"
        status = "active"
        curr_status = "started"
        alert = "Expert Started Job"
      elsif params[:pause]
        type = "expert_paused"
        curr_status = "paused"
        status = "paused"
        alert = "Expert Paused Job"
      elsif params[:end]
        type = "expert_ended"
        curr_status = "ended"
        status = "completed"
        alert = "Expert ended Job"
        date = Time.now
      elsif params[:restart]
        type = "expert_restarted"
        curr_status = "restarted"
        status = "paused"
        alert = "Expert restarted Job"
        reason = params[:restart_reason]
      elsif params[:confirm]
        type = "Expert Accept to Restart"
        alert = "Expert Accepted"
        status = "active"
        curr_status = "started"
      elsif params[:cancel]
        type = "Expert Cancel to Restart"
        alert = "Expert Cancelled"
        status = "cancelled"
        curr_status = "cancelled"
        cancelled = "expert"
      end
        
      job.update_attributes(:status => status, :current_status=> curr_status,
                            :restart_reason => reason, :completed_date => date, :cancelled_by => cancelled)
      
      if !job.restart_reason.nil?
        re_reason = job.restart_reason
      else
        re_reason = ""
      end
      
      pusher = Grocer.pusher(
        certificate: "#{Rails.root}/public/consumer.pem",      
        passphrase:  "Sybrant123",                       
        gateway:     "gateway.sandbox.push.apple.com", 
        port:        2195,                     
        retries:     3                         
      )
      # Environment variables are automatically read, or can be overridden by any specified options. You can also
      notification = Grocer::Notification.new(
        device_token: job.user.device_token.device_token,
        alert:             alert,
        sound:             "siren.aiff",
        badge:        0,
        custom: { "job" => job.id, "type" => type, "reason" => re_reason, "expert" => job.expert.first_name, "latitude" => @@lat_param, "longitude" => @@lon_param }
      )

      pusher.push(notification)
    end
  end

  #Reject consumer call request
  def reject_call_request
    job = Job.find(params[:job_id])
    if job.destroy
       pusher = Grocer.pusher(
        certificate: "#{Rails.root}/public/consumer.pem",      
        passphrase:  "Sybrant123",                       
        gateway:     "gateway.sandbox.push.apple.com", 
        port:        2195,                     
        retries:     3                         
      )
      # Environment variables are automatically read, or can be overridden by any specified options. You can also
      notification = Grocer::Notification.new(
        device_token: job.user.device_token.device_token,
        alert:   "Expert Rejected the call",
        badge:        0,
        sound:             "siren.aiff",
        custom: { "job" => job.id, "type" => "Expert_rejected_call"}
      )

      pusher.push(notification)
   end
  end
  #Reject consumer call request
  def call_status
    job = Job.find(params[:job_id])
    if !job.expert_id.blank? or !job.expert_id.nil?
      render :json=> {:success => false }
    else
      if params[:accept]
        job.update_attributes(:status => "completed", :expert_id => params[:expert_id])
      elsif params[:end]
       job.update_attributes(:status => "active")
      end
    end
  end
  #get dashboard values
  def dashboard
    @results = GoogleCustomSearchApi.search("Computer")
    
  end
  #Update Expert Lat and Long
  def update_expert_location
    @exp  = Expert.find(params[:expert_id])
    #@job = Job.find(params[:job_id])
    if @exp.update_attributes(:latitude => params[:lat], :longitude => params[:lon])
      render :json=> {:success => true, :lat => @exp.latitude, :lon => @exp.longitude}, :status=>200
    else
      render :json=> {:success => false}, :status=>204
    end 
  end
end
 