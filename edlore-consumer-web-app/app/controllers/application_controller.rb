class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # before_filter :authenticate_user!
  protect_from_forgery with: :exception
  before_filter :require_login
  before_filter :update_sanitized_params, if: :devise_controller?
  #get update params for user model with devise gem
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :phone)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email, :password, :password_confirmation, :phone)}
  end
  #set redirect path after sign_in
  def after_sign_in_path
     
     experts_path

  end
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  #check curent user is logged in or not
  def check_user
   if current_user.blank?
    puts"false"
    new_user_session_path
   else
    puts"true"
   end
  end

  def admin_search_options
    @search_options = Expert.select(:city).uniq
  end

  private

  def require_login
    unless current_user
      jobs_path
    end
  end
end
