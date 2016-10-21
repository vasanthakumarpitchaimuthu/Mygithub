=begin
  Registration Api Controller for mobile json
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class Api::V1::RegistrationsController < ApplicationController
  respond_to :json
  #before filter for check the token verification
  skip_before_filter :verify_authenticity_token
  
  #Register new consumer via mobile app
  def create
    user = User.new    
    user.email = params[:email]
    user.password = params[:password]
    user.username = params[:user_name]
    user.phone = params[:phone]
    user.user_type = "consumer"
    if user.save
      DeviceToken.create(:device_token=>params[:device_token],:user_id=>user.id)
      render :json=> {:success=>true, :id=>user.id, :email=>user.email}, :status=>200
      return
    else
      warden.custom_failure!
      #render :json=> user.errors, :success=> false, :status=>422
      render :json=> {:success=> false, :status=>422}
    end
  end

  #Edit and update the user details
  def update_details
    user = User.find_by_id(params[:user_id])
    if user.update_attributes(:username => params[:user_name], :phone => params[:phone],
                              :city => params[:city])
      render :json=> {:success=>true, :id=>user.id, :email=>user.email}, :status=>200
      return
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end
  end
  #Recover password
  def forgot_password
    generated_password = Devise.friendly_token.first(8)
    user = User.find_for_database_authentication(:email=>Base64.decode64(params[:email]))
    return invalid_email_id unless user
    user.password = generated_password
    if user.save
      UserMailer.forgot_password(user).deliver
      render :json=> {:success=>true}, :status=>401
    end
    
  end
  #change the pasword
  def update_password
    user = User.find_by_id(params[:user_id])
    if user.valid_password?(Base64.decode64(params[:old_password]))
      user.password = params[:new_password]
      if user.save
        render :json=> {:success=>true}, :status=>200
      end
    else
      render :json=> {:success=>false, :message=>"Wrong old password"}, :status=>422
    end
  end

  #Set the notification status
  def notification_status
   consumer = User.find_by_id(params[:user_id])
   if consumer.update_attributes(:notification_status => params[:status],
                                 :call_time => params[:call_time])
    render :json=> {:success=>true}, :status=>200
   else
    render :json=> {:success=>false, :message=>"Something wrong"}, :status=>401
   end
  end
  
  #Delete user account
  def delete_account
    user = User.find_by_id(params[:user_id])
    user.delete_at = 1
    user.save
    render :json=> {:success=>true, :message => "User was successfully destroyed."}, :status=>200
  end

  protected

    def invalid_login_attempt
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>422
    end

    def invalid_email_id
      render :json=> {:success=>false, :message=>"Invalid Email"}, :status=>422
    end
end
