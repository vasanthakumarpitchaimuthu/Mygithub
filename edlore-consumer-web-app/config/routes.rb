Rails.application.routes.draw do
  # Routes for API controllers
  namespace :api , defaults: { format: 'json' } do  
    namespace :v1 do
      devise_scope :users do
        post "/sign_in", :to => 'sessions#create'
        delete "/sign_out", :to => 'sessions#destroy'
        post "/register", :to => 'registrations#create'
        post"/forgot_password", :to => 'registrations#forgot_password'
        post"/update_password", :to => 'registrations#update_password'
        post"/update_details", :to => 'registrations#update_details'
        post"/delete_account", :to => 'registrations#delete_account'
        post"/job", :to => 'jobs#create'
        post '/notification_status' => 'registrations#notification_status'
        post '/expert_mode' => 'expert_tags#expert_mode'
        post '/purchase_parts' => 'products#purchase_parts'
        post '/expert_to_consumer_notifications' => 'experts#expert_to_consumer_notifications'
        post '/expert_accept_help' => 'experts#expert_accept_help'
        post '/consumer_to_expert_notifications' => 'consumers#consumer_to_expert_notifications'
        post '/confirm_expert' => 'consumers#confirm_expert'
        post "/consumer_feedback" => 'consumers#consumer_feedback'
        post "/stripe_token" => 'consumers#stripe_token'
        get '/check_stripe_token' => 'jobs#check_stripe_token'
        # post '/payment' => 'jobs#payment'
        match '/payment', :to => 'consumers#payment', :as => 'payment', :via => [:post]  

        post "/report_issue" => 'jobs#report_issue'
        post '/send_invoice_mail' => 'jobs#send_invoice_mail'
        get '/experts_call_list' => 'jobs#experts_call_list'
        post '/purchase_parts' => 'products#purchase_parts'
        post '/purchase_response' => 'products#purchase_response'
        post '/reject_call_request' => 'experts#reject_call_request'
        post '/call_status' => 'experts#call_status'
        get '/dashboard' => 'experts#dashboard'
        get '/get_product_details' => 'products#get_product_details'
        post '/get_experts_list' => 'jobs#get_experts_list'
        get '/get_job_details' => 'experts#get_job_details'
        get '/review_feedback' => 'experts#review_feedback'
        get "/save_consumer_manuals" => 'consumers#save_consumer_manuals'
        get '/get_manuals', :to => 'consumers#get_manuals'
        get '/get_reference_manuals', :to => 'consumers#get_reference_manuals'
        get '/get_make_model_manuals', :to => 'consumers#get_make_model_manuals'
        get '/get_expert_type', :to => 'consumers#get_expert_type'
        get '/consumer_job_details', :to => 'jobs#consumer_job_details'
        get '/expert_job_details', :to => 'experts#expert_job_details'
        post '/update_expert_location', :to => 'experts#update_expert_location'
        resources :expert_tags
        #resources :jobs
      end
    end
  end
  
  resources :experts do   
  collection do
    get 'get_values', to: "experts#get_values"
  end 
end 


  #match "/get_job_details" => "api::v1::expert_tags#get_job_details", :defaults => { :format => 'json' }
  #Route with devise gem 
  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  #root path
  root :to => "dashboard#index"
  # resources routes
  resources :jobs
  resources :experts
  resources :sub_categories
  resources :categories
  resources :complaints
  resources :charges
  resources :consumers
  

  #expert and consumer job details 
  get '/experts/:id/expert_job_details', to: 'experts#expert_job_details', as: 'expert_job_details'
  get '/consumer/:id/consumer_job_details', to: 'consumer#consumer_job_details', as: 'consumer_job_details'
  
  #Reports
  get '/print_category_list' => 'reports#print_category_list'
  get '/print_job_details'   => 'reports#print_job_details'
  get '/print_categories'    => 'reports#print_categories'
  get '/print_expert_details'=> 'reports#print_expert_details'
  get '/print_consumer_details' => 'reports#print_consumer_details'
end
