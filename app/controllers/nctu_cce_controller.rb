class NctuCceController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :indexManagement]
  before_action :set_progress, only: [:showProgress, :verified, :cancel]  
    
  def new
    @group = Group.new( module: params[:module])
    @group.items.build(verification_code: params[:verification_code])    
  end
  
  def create
    @group = Group.new(group_params) 
    @group.items.first.user = current_user 
    if @group.save
      redirect_to controller: :items, action: :createCompletion, id: @group.items.first.id
    else
      render :new
    end    
  end 
  
  def edit
  end 
  
  def update
    
  end
  
  def first
    @user=current_user
    unless params[:item_id].blank?
      @item=Item.find(params[:item_id])
    end  
    unless params[:progress_id].blank?
      @progress=Progress.find(params[:progress_id])      
    end
  end
  
  def second
    if params[:progress_id].blank?
      @user=current_user  
      @user.assign_attributes(user_params)      
      userBirthdayValidate user_params[:birthday]
      userGenderValidate user_params[:gender]
      userPhoneNoValidate user_params[:phone_no]
      userPostalValidate user_params[:postal]
      userCountyValidate user_params[:county]
      userDistrictValidate user_params[:district]
      userAddressValidate user_params[:address]
      userIDNoTWValidate user_params[:id_no_TW]
      if @user.errors.empty?
        @progress=Progress.new
        @progress.stage=2
        @progress.user = current_user      
        @user.save!        
        @progress.item = Item.find(params[:item_id])
        @progress.save!  
      else
        render :first
      end          
    else
      @user = current_user    
      #@user.update(user_params)     
      @progress = Progress.find(params[:progress_id])     
      @progress.stage=2
      @progress.save!    
    end    
  end
  
  def third
    
  end  
  
  def indexManagement
    
  end  
  
  def showProgress
    
  end
  
  def cancel
    @progress.destroy!
    redirect_to controller: 'items', action: 'progress', finished: false   
  end
  
  def verified
    if @progress.verified
      @progress.verified=false
      @progress.stage=2
      @progress.save!
      flash[:alert]="已取消通過 "+@progress.user.name+" 的報名"
    else
      @progress.verified=true
      @progress.stage=3      
      @progress.save!    
      flash[:success]="已審核通過 "+@progress.user.name+" 的報名"
    end
    redirect_to controller: 'nctu_cce', action: 'showProgress', id: @progress.id
  end  
  
  private
    def set_item
      @item = Item.find(params[:id])
    end
    
    def set_progress
      @progress = Progress.find(params[:id])     
    end
    
    def user_params
      params.require(:user).permit(:name, :birthday, :gender, :id_no_TW, :phone_no, :address, :postal, :county, :district)      
    end

    def group_params
      params.require(:group).permit(:module, :title, :description, items_attributes: [:verification_code, :no_of_user, :price,
                                    :start_at, :end_at, :payment_strat_at, :payment_end_at, :school_year, :semester, :term])
    end  
end
