=begin
  ExpertsController
  Application :EdloreConsumer
  Created by Sybrant 
  Copyright (c) 2015 Edlore. All rights reserved.
=end
class ExpertsController < ApplicationController
  before_action :set_expert, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, if: :skip_authenticate_user    # skip_before_action :authenticate_user!
  # GET /experts       
  # GET /experts.json

  
# def index
#   if (params[:category_name] && Category.all.collect(&:category_name).include?(params[:category_name][:id]))
#      @categories = Category.send(params[:category_name][:id].downcase).all.order(params[:sort])
#      @experts = Expert.search(params[:search]).order(params[:sort])

#   else
#  @experts = Expert.search(params[:search]).order(params[:sort])
#     @categories = Category.all.order(params[:sort])  end
# end

  # def index      
  #   @experts = Expert.search(params[:search]).where(params[:select])
  #   @categories = Category.all.order(params[:select])
  # end

  def index  
    # raise params.inspect 
    admin_search_options
    @experts = Expert.search(params[:search])
    @categories = Category.all
    # @categories = Category.all.order(params[:search])
    # @exp = Expert.where(:category_id)
    # @q = Expert.search(params[:q])
    # @gra = @q.result(:distinct => true)
    # @cat = Category.search(params[:search])
  end
  # def index
  # #    if params[:publication]
  # #   @publications = Publication.filter(params[:publication][:category])
  # # else
  # #   @publications = Publication.all
  # # end 
    
  # end
  # GET /experts/1
  # GET /experts/1.json
  def show
  end
  # GET /experts/new
  def new
    @expert = Expert.new
   # @subcatogoryid = SubCategory.where( 'category_id = ?',session[:category_id])
   @subcatogoryid = SubCategory.where(:category_id=>session[:category_id])
  
  end

  # GET /experts/1/edit
  def edit
  end

  def get_values      
     
   @category1 = Category.find params[:category_id]
   @sub_cat = @category1.sub_categories
   
  
end 

  # POST /experts
  # POST /experts.json
  
  def create
    # @category_list = Category.find(session[:category_id])
    @subcatogoryid = SubCategory.where(:category_id=>session[:category_id])
    @expert = Expert.new(expert_params)

    respond_to do |format|
      if @expert.save
        generated_password = Devise.friendly_token.first(8)
        user = User.new
        user.email = @expert.email
        user.expert_id = @expert.id
        user.password = generated_password
        user.user_type = "expert"
        if user.save
         UserMailer.send_expert_password(user).deliver
        end 
        format.html { redirect_to @expert, notice: 'Expert was successfully created.' }
        format.json { render :show, status: :created, location: @expert }
      else
        format.html { render :new }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experts/1
  # PATCH/PUT /experts/1.json
  def update
    respond_to do |format|
      if @expert.update(expert_params)
        format.html { redirect_to @expert, notice: 'Expert was successfully updated.' }
        format.json { render :show, status: :ok, location: @expert }
      else
        format.html { render :edit }
        format.json { render json: @expert.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /experts/1
  # DELETE /experts/1.json
  def destroy
    @expert.destroy
    respond_to do |format|
      format.html { redirect_to experts_url, notice: 'Expert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def assign_user
    unless params[:category_id].blank?
    @sub_category = SubCategory.where('id !=? and category_id = ?',current_user.id,params[:category_id]).compact
    else
      @sub_category = []
    end
    
  end



  def load_sub_categories       
    term = params[:term]
    cat_id = params[:sub_cat_id]
    @sub_cat_name = SubCategory.where(:category_id=> params[:cat_id]).where{ sub_cat_name =~ "%#{term}%" }.map {|model| {:id => model.id, :name => model.sub_cat_name, :label => model.sub_cat_name}}
    #@device_name = (select * from modelnames where device_name like "%term%");
     respond_to do |format|
      format.js
      format.json { render :json => @sub_cat_name }
    end
  end
  
  private    
    # Use callbacks to share common setup or constraints between actions.
    def set_expert
       @expert = Expert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expert_params
      params.require(:expert).permit(:expert_id, :first_name, :last_name, :phone, :city, :state,
                                     :country, :category_id, :sub_category_id, :expert_user_id,
                                     :address, :latitude, :longitude, :zipcode, :email)
    end

     protected
    def skip_authenticate_user
      action_name=='index'  && (request.format.json? || request.format.xml?)
    end
end