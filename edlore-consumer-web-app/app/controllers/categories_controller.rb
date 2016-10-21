=begin
  CategoriesController
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    @category.sub_categories.build
       @subcatogoryid = SubCategory.where(:category_id=>session[:category_id])

  end     

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
       @subcatogoryid = SubCategory.where(:category_id=>session[:category_id])

    @category = Category.new(category_params)

   
      if @category.save
        redirect_to :experts
      else
        render :new
     
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    
      if @category.update(category_params)
        redirect_to experts_path
      else
        redirect_to edit_category_path
      end
    
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to experts_path, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  # def get_subcategory_list
  #   @sub_category_list  = SubCategory.where(:category_id => params[:category_id])
  #   respond_to do |format|      
  #     format.js {}
  #   end
  # end
   def get_subcategory_list
    @subcatogoryid = SubCategory.where(:category_id=>session[:category_id])
    # @sub_category_list  = SubCategory.where(:category_id => params[:category_id])
    respond_to do |format|      
      format.js {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
     params.require(:category).permit(:category_name, sub_categories_attributes: [:id, :sub_cat_name, :_destroy])
    end
end
