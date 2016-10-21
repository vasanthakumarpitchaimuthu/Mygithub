=begin
  Consumers Api Controller for mobile json
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class Api::V1::ConsumersController < ApplicationController
 #before filter for check the token verification 
 skip_before_filter :verify_authenticity_token
      
 #getting manuals based on Consumer text serarch
  def get_manuals
   @manuals = Manual.where(:sub_category_id => params[:sub_cat_id])
    
    @consumer_manuals = []  
      @manuals.each do |manual|
        @consumer_manuals << {:id => manual.id, :manual_name=> manual.download_title, 
        	                  :manual_url => manual.download_url, :create_date => manual.created_at}
      end 
  end
  #Consumer save some manuals for reference
  def save_consumer_manuals
    manual = ConsumerManual.where(:consumer_id => params[:user_id], :manual_id => params[:manual_id])
    @con_manual = ConsumerManual.create(:user_id => params[:user_id], :consumer_id => params[:user_id], 
                                        :manual_id => params[:manual_id]  )
  	if @con_manual.create
      render :json=> {:success => true}, :status=>200
    else
      render :json=> {:success => false}, :status=>204
    end
  end

  #Shwoing Consumer Reference manuals already saved one
  def get_reference_manuals
  	@manuals = ConsumerManual.where(:user_id => params[:user_id])
  	@consumer_ref_manuals = []
      @manuals.each do |manual|
        @ref_manuals = Manual.where(:id => manual.manual_id)
        @ref_manuals.each do|ref_manu|
          @consumer_ref_manuals << {:id => ref_manu.id, :manual_name=> ref_manu.download_title, 
        	                      :manual_url => ref_manu.download_url, :create_date => ref_manu.created_at}
        end
      end 
  end

  #get automative depends on consumer request
  def get_expert_type
    text = params[:job_name].downcase.split(' ')
      text.each do|word|
        @expert_tag = ExpertTag.all
        @expert_tag.each do|exp|
          if exp.tag_name.include?(word)
            @cat = exp.expert.category
            @sub_cat = exp.expert.sub_category
          end
        end
      end

      if !@cat.blank? && !@sub_cat.blank?
        render :json=> {:success => true,:cat_id => @cat.id,
                        :cat_name => @cat.category_name, :sub_cat_id => @sub_cat.id, :sub_cat_name => @sub_cat.sub_cat_name}, :status=>200
      else
        render :json=> {:success => false, :cat_id => "", :sub_cat_id => ""}, :status=>200
      end
  end

  #get manuals based on make and model
  def get_make_model_manuals
    if !params[:sub_cat_id].blank?
      @manuals = Manual.where(:sub_category_id => params[:sub_cat_id])
    else
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

      @manuals = Manual.where(:sub_category_id => @sub_cat.id)
    end
    @consumer_manuals = []
      @manuals.each do |manual|
        @consumer_manuals << {:id => manual.id, :manual_name=> manual.download_title, 
                            :manual_url => manual.download_url, :create_date => manual.created_at}
      end 
   
   end
  #Consumer Confirm the expert
  def confirm_expert
    @ids = []
     job = Job.create(:issue_name => params[:issue_name], :received_date => Time.now, :category_id => params[:cat_id], :sub_category_id => params[:sub_cat_id],
                            :user_id => params[:consumer_id], :input_type => params[:input_type], :make => params[:make], :visit_address => params[:address],
                            :status => "new", :current_status => "new", :latitude => params[:lat], :longitude => params[:lng])
    lat = params[:lat].to_f
    lan = params[:lng].to_f
    text = params[:issue_name].downcase.split(',')
    text.each do|word|
      @tags = ExpertTag.where("tag_name LIKE ?", "%#{word}%") 
        @tags.each do |tag|
          @experts = Expert.near([lat, lan], 20).where(:id => tag.expert_id, :expert_mode => 1)
              if @experts.present? 
                @experts.each do |expert|
                  @users = User.where(:expert_id => expert.id)
                  @users.each do |user|
                   @ids << user.id
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
                        alert:             "New Job Confirmation",
                        sound:             "siren.aiff",
                        badge:        0,
                        custom: {"job" => job.id, "type" => "new_job_request" }
                      )

                      pusher.push(notification) # return value is the number of bytes sent successfully
                 end
                  end
                end
                
            end
        end
    end
      ExpertNotification.create(:expert_id => @ids.join(","), :job_id => job.id)
      if @experts.present?
       render :json=> {:success => true, :job_id => job.id ,:message => "Expert Confirmed"}, :status=>200
      else
       render :json=> {:success => false ,:message => "No_experts_found"}, :status=>200
      end
  end
  #consuer Feedback
  def consumer_feedback

    if !params[:description].blank? or !params[:rating].blank?
       Feedback.create(:description => params[:description], :job_id => params[:job_id],
                     :rating => params[:rating], :user_id => params[:consumer_id], :expert_id => params[:expert_id])
      render :json=> {:success => true,:message => "Thanks For your Feedback"}, :status=>200
    else
      render :json=> {:success => false,:message => "Something Wrong"}, :status=>204
    end
    
  end
#  def payment
#     # get the credit card details submitted by the form or app
# token = params[:stripe_token]
# puts"=====strrr===#{token}========="
#  @amount = params[:call_duration].to_i * 100
#   cus = Customer.where(:user_id => params[:consumer_id])
#   usrrr = User.find(params[:consumer_id])
#     puts"---@cus------#{usrrr}-----------"
#       puts"---@cus------#{usrrr.id}-----------"


   
# # if !@usrrr.stripetoken.blank?
# #   puts"===iii===#{@usrrr.id}======"
# #   puts"---have----"
# # else
# #   puts"-----donthave-------" 
# # end


# # create a Customer
# customer = Stripe::Customer.create(
#   card: token,
#   description: 'description for payinguser',
# )

# # charge the Customer instead of the card
# Stripe::Charge.create(
#     amount: @amount, # in cents
#     currency: 'usd',
#     customer: customer.id
# )
# # save the customer ID in your database so you can use it later
# save_stripe_customer_id(customer.id)

# # later
# customer_id = get_stripe_customer_id(user)

# Stripe::Charge.create(
#     amount: @amount, # $15.00 this time
#     currency: 'usd',
#     customer: customer_id
# )
#   # custome = Customer.create(:user_id => params[:consumer_id],
#   #      :pay => @amount, :stripetoken => params[:stripe_token])

    
#    end

# #stripe_payment method

# def payment
#   token = params[:stripe_token]
#   puts"---token-----#{params[:stripe_token]}--------------"
#   amount = params[:call_duration].to_i*100
#   puts"-----amount----#{amount}---------------"

# # Create a charge: this will charge the user's card
# begin
#   charge = Stripe::Charge.create(
#     :amount => amount, # Amount in cents
#     :currency => "usd",
#     :source => token,
#     :description => "Example charge"
#   )
# rescue Stripe::CardError => e
#   end


# end
def payment
    tot = params[:call_duration].to_i
    @amount = tot * 100
  

   

  #Enter Customer Details
   customer = Customer.create(:user_id => params[:consumer_id],
                              :stripetoken => params[:stripe_token], :pay => tot)  
 # Amount in cents
  customer = Stripe::Customer.create(
    :email => params[:customer_email],
    #:card  => params[:stripeToken]
  )

    @jobb = Job.find(params[:job_id])
     puts"-----@jobb------#{@jobb}----------"    

    @jobb.update_attributes(:payment => tot)
   #  ccc = Customer.where(:user_id => params[:consumer_id])
   #  puts"==ccc===#{ccc}================"
   #     puts"==ccc===#{ccc.id}================"

   #  ccc.update_attributes(:pay => @amount)
   # puts"==ccc===#{ccc}================"

  puts "---cusssssss--------#{customer}-----------------"
  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )
     puts "-----------#{charge}-----------------"

   rescue Stripe::CardError => e
    flash[:error] = e.message
   render :json=> {:success => true,:message => "Payment Success",:amount => tot }, :status=>200



  
end
  #save consumer stripe Token
  def stripe_token     
         puts"===uid=====#{params[:user_id]}==============="
                  puts"====stkn====#{params[:stripe_token]}==============="
      
      pay_id = params[:user_id]
     
     # Customer.create(:stripetoken => params[:stripe_token], :user_id => params[:user_id])
     @user = User.find(params[:user_id])
     @user.update_attributes(:stripetoken => "true")
    render :json=> {:success => true}, :status=>200
  end     
  #consumer send notifications to experts
  def consumer_to_expert_notifications
    job = Job.find_by_id(params[:job_id])
    if job.status == "new" and params[:cancel]
      job.update_attributes(:status => "cancelled", :current_status=> "cancelled")
    else
      if params[:pause]
        type = "consumer_paused"
        curr_status = "paused"
        status = "paused"  
        alert = "Consumer Paused Job"
      elsif params[:end]
        type = "consumer_ended"
        curr_status = "ended"
        status = "completed"
        alert = "Consumer ended Job"
        date = Time.now
      elsif params[:restart]
        type = "consumer_restarted"
        curr_status = "restarted"
        status = "paused"
        alert = "Consumer restarted Job"
        reason = params[:restart_reason]
      elsif params[:confirm]
        type = "Consumer Accept to Restart"
        alert = "Consumer Accepted"
        status = "active"
        curr_status = "started"
      elsif params[:cancel]
        type = "Consumer Cancel to Restart"
        alert = "Consumer Cancelled"
        status = "cancelled"
        curr_status = "cancelled"
        cancelled = "consumer"
      end
        
      job.update_attributes(:status => status, :current_status=> curr_status, :completed_date => date, 
                            :restart_reason => reason, :cancelled_by => cancelled)  
      
      user = User.where(:expert_id => job.expert_id).first
      pusher = Grocer.pusher(
        certificate: "#{Rails.root}/public/expert.pem",      
        passphrase:  "Sybrant123",                       
        gateway:     "gateway.sandbox.push.apple.com", 
        port:        2195,                     
        retries:     3                         
      )
      # Environment variables are automatically read, or can be overridden by any specified options. You can also
      notification = Grocer::Notification.new(
        device_token: user.device_token.device_token,
        alert:             alert,
        sound:             "siren.aiff",
        badge:        1,
        custom: { "job" => job.id, "type" => type, "reason" => job.restart_reason, "consumer" => job.user.username }
      )

      pusher.push(notification)
    end
  end
  def consumer_params
      params.require(:customer).permit(:customer, :amount, :description, :currency, :user_id, :expert_id, :pay, :stripetoken)
    end

end
