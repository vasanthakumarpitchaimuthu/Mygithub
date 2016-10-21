=begin
  UsersController
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class UsersController < ApplicationController
before_filter :user_access,:except => [:sign_in]
  def edit
  end

  def update
  end
end
