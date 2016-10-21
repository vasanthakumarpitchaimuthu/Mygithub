# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

#Configure for mail sending
ActionMailer::Base.smtp_settings = {
      :address => "email-smtp.us-east-1.amazonaws.com",
      :user_name      => 'AKIAIJTVFAIC4EGUM3RA',
      :password       => 'Al3n2pZHAvjFg1u/sWzhlxLS5mK2odYz2+uek3iaOcu5',
      :authentication => :plain,
      :enable_starttls_auto => true,
  	  :domain         => 'amazon.com',
  	  :enable_starttls_auto => true
}
