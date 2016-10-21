=begin
  Sessions Api Controller for mobile json
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class Api::V1::SessionsController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [:create ]
  #include Devise::Controllers::InternalHelpers
  skip_before_filter :verify_authenticity_token 
  before_filter :ensure_params_exist
 
  #respond_to :json
  #login 
  def create
    resource = User.find_for_database_authentication(:email=>Base64.decode64(params[:email]))
    return invalid_login_attempt unless resource
    
    if resource && params[:device_token].present?   
      already_exist_token = DeviceToken.where(:user_id => resource.id)
      already_exist_token.each{|s| s.destroy}  unless already_exist_token.blank? 
      DeviceToken.where(:device_token=>params[:device_token],:user_id=>resource.id).create
    end
    
    if resource.user_type == params[:user_type]
      if resource.valid_password?(Base64.decode64(params[:password]))
        sign_in("user", resource)
        render :json=> {:success=>true, :id=> resource.id, :email=>resource.email, :username =>resource.username, :phone =>resource.phone,
                        :city=> resource.city, :notification_status => resource.notification_status, :call_time => resource.call_time, :keyword_id => resource.expert_id}
        return
      end
    end
    invalid_login_attempt
  end
  
  #kill the session
  def destroy
    sign_out(resource_name)
  end
 
  protected
    def ensure_params_exist
      return unless params[:email].blank? || params[:password].blank?
      render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status =>422
    end
   
    def invalid_login_attempt
      warden.custom_failure!
      render :json=> {:success=>false, :message=>"Invalid login details"}, :status =>401
    end
end
  
