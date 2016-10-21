=begin
  Experts Api Controller for mobile json
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class Api::V1::ExpertTagsController < ApplicationController
 before_action :set_expert_tag, only: [:show, :edit, :update, :destroy]
 skip_before_filter :verify_authenticity_token
  # GET /api/v1/expert_tags
  # GET /api/v1/expert_tags.json
  def index
    @expert_tags = ExpertTag.where(:user_id => params[:user_id])
  end

  # GET /api/v1/expert_tags/1
  # GET /api/v1/expert_tags/1.json
  def show
  end

  # GET /api/v1/expert_tags/new
  def new
    @expert_tag = ExpertTag.new
  end

  # GET /api/v1/expert_tags/1/edit
  def edit
  end

  # POST /api/v1/expert_tags
  # POST /api/v1/expert_tags.json
  def create
    @expert_tag = ExpertTag.new
    @expert_tag.tag_name = params[:tag_name].downcase
    @expert_tag.user_id = params[:user_id]
    @expert_tag.expert_id = params[:expert_id]
    if @expert_tag.save
      render :json=> {:success => true, :id => @expert_tag.id}, :status=>200
    else
      render :json=> {:success => false}, :status=>204
    end
  end

  # PATCH/PUT /api/v1/expert_tags/1
  # PATCH/PUT /api/v1/expert_tags/1.json
  def update
    respond_to do |format|
      if @expert_tag.update_attributes(:tag_name => params[:tag_name], :user_id => params[:user_id])
        format.html { redirect_to @expert_tag, notice: 'Expert tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @expert_tag }
      else
        format.html { render :edit }
        format.json { render json: @expert_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/expert_tags/1
  # DELETE /api/v1/expert_tags/1.json
  def destroy
    if @expert_tag.destroy
     render :json=> {:success => true}
    else
     render :json=> {:success => false}
    end
  end

  def expert_mode
   expert_mod = Expert.find_by_id(params[:expert_id])
   if expert_mod.update_attributes(:expert_mode => params[:mode])
    render :json=> {:success => true}
   else
    render :json=> {:success => false}
   end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expert_tag
      @expert_tag = ExpertTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expert_tag_params
      params.require(:expert).permit(:tag_name, :user_id, :expert_id)
    end
end
