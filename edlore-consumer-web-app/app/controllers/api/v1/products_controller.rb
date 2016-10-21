=begin
  Products Api Controller for mobile json
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class Api::V1::ProductsController < ApplicationController
 respond_to :json
  #before filter for check the token verification
  skip_before_filter :verify_authenticity_token
  #purchase products as per consumer help request
  def purchase_parts
    @product = PurchasePart.new(:part_name => params[:part_name],
                                  :expert_id => params[:expert_id],
                                  :job_id => params[:job_id],
                                  :price => params[:price],
                                  :quantity => params[:quantity],
                                  :total_amount => params[:total_cost])
    if @product.save 
      @main_dir = FileUtils.mkdir_p("#{Rails.root}/app/assets/images/product_images/#{@product.job_id.to_s}/#{@product.id.to_s}")
      @img_save_dir="#{Rails.root}/app/assets/images/product_images/#{@product.job_id.to_s}/#{@product.id.to_s}/"
      File.open("#{@img_save_dir}#{@product.id}.png", 'wb') do|f|
       f.write(Base64.decode64(params[:image]))
      end
      pusher = Grocer.pusher(
        certificate: "#{Rails.root}/public/consumer.pem",      
        passphrase:  "Sybrant123",                       
        gateway:     "gateway.sandbox.push.apple.com", 
        port:        2195,                     
        retries:     3                         
      )
      # Environment variables are automatically read, or can be overridden by any specified options. You can also
      notification = Grocer::Notification.new(
        device_token: @product.job.user.device_token.device_token,
        alert:  "Purchase Parts Approval",
        badge:        0,
        sound:             "siren.aiff",
        custom: { "product" => @product.id, :job_id => @product.job_id, "type" => "Purchase Parts Approval"}
      )

      pusher.push(notification)
      render :json=> {:success => 1}, :status=>200
    end
  end
  #get the product details which already request sent
  def get_product_details
  	@product = PurchasePart.find(params[:pro_id])
  	if !@product.blank?
  	  render :json=> {:success => 1, :image_url => @product.purchase_url, :product_id => @product.id, :part_name => @product.part_name, :expert => @product.expert.first_name, :quantity => @product.quantity, :total => @product.total_amount}, :status=>200
  	else
  	 render :json=> {:success => 0}, :status=>200
  	end
  end
  #get purchase product response from consumers
  def purchase_response
    if params[:accept]
      type = "accepted"
      status = "confirmed"
      alert = "Consumer Accepted"
    elsif params[:hold]
      type = "on-hold"
      status = "hold"
      alert = "Consumer Paused Job"
    elsif params[:end]
      type = "rejected"
      status = "ended"
      alert = "Consumer ended Job"
    end
     
    product = PurchasePart.find(params[:pro_id]) 
    product.status = status
    product.user_id = params[:consumer_id]
    product.save
    pusher = Grocer.pusher(
      certificate: "#{Rails.root}/public/expert.pem",      
      passphrase:  "Sybrant123",                       
      gateway:     "gateway.sandbox.push.apple.com", 
      port:        2195,                     
      retries:     3                         
    )
    # Environment variables are automatically read, or can be overridden by any specified options. You can also
    notification = Grocer::Notification.new(
      device_token: product.expert.user.device_token.device_token,
      alert:             alert,
      sound:             "siren.aiff",
      badge:        0,
      custom: {"type" => type, "job" => product.job_id, "consumer" => product.user.username}
    )

    pusher.push(notification)
  end
end
