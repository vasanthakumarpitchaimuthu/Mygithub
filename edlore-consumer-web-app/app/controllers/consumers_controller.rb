=begin
  ConsumersController
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class ConsumersController < ApplicationController
 skip_before_filter :verify_authenticity_token	
 before_action :set_consumer, only: [:show]
 
 
 #get consumers list 
 def index
   @consumers = User.where(:user_type => "consumer").search(params[:search])
   @users = User.all
 end

  private   
    # Use callbacks to share common setup or constraints between actions.
    def set_consumer
      @consumer = User.find(params[:id])
    end
end
