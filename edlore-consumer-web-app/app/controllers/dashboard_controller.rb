=begin
  DashboardController
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class DashboardController < ApplicationController
  def index
  	@jobs = Job.where(:status => "completed").limit(10)
  	@conusmers = User.where(:user_type => 'consumer')
  	@today = User.where(:user_type => 'consumer', :created_at => Date.today)
  	@complaints = Complaint.all
  end
end
