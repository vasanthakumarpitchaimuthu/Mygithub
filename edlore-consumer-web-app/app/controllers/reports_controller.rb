=begin
  ReportssController
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class ReportsController < ApplicationController
  #get expert details report
	def print_expert_details
	  @experts = Expert.all
	  html = render_to_string(:layout => false, :action => "print_expert_details.html.erb")
	  kit = PDFKit.new(html)
	  send_data(kit.to_pdf, :filename => 'Expert_Details.pdf', :type => 'application/pdf',:target => '_blank')
  end
  #get category details report
  def print_category_list
	  @categories = Category.all
	  html = render_to_string(:layout => false, :action => "print_categories.html.erb")
    kit = PDFKit.new(html)
	  send_data(kit.to_pdf, :filename => 'Categeory_Details.pdf', :type => 'application/pdf',:target => '_blank')
	end
  #get consumer details report
  def print_consumer_details
    @consumers = User.where(:user_type => "consumer")
    html = render_to_string(:layout => false, :action => "print_consumer_details.html.erb")
    kit = PDFKit.new(html)
    send_data(kit.to_pdf, :filename => 'Consumer_Details.pdf', :type => 'application/pdf',:target => '_blank')
  end
  #get job details report
  def print_job_details
    @jobs = Job.all
    html = render_to_string(:layout => false, :action => "print_job_details.html.erb")
    kit = PDFKit.new(html)
    send_data(kit.to_pdf, :filename => 'Help_List.pdf', :type => 'application/pdf',:target => '_blank')
  end
end
