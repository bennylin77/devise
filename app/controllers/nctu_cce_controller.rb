class NctuCceController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :indexManagement]
  before_action :set_progress, only: [:showProgress, :verified, :cancel]  
    
  def new
    @group = Group.new( module: params[:module])
    @group.items.build()    
  end
  
  def create
    @group = Group.new(group_params)      
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description},
                                    {type: 'presence', title: '報名人數', data: @group.items.first.no_of_user},
                                    {type: 'presence', title: '金額', data: @group.items.first.price},
                                    {type: 'presence', title: '報名開放時間', data: @group.items.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.items.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_strat_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_strat_at, second: @group.items.first.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' )   
    @group.items.first.user = current_user 
    @group.save  
    redirect_to controller: :items, action: :createCompletion, id: @group.items.first.id  
  end 
  
  def edit
  end 
  
  def update
    
  end
  
  def first
    @user=current_user
    @item=Item.find(params[:item_id])
=begin    
    unless params[:item_id].blank?
      @item=Item.find(params[:item_id])
    end  
    unless params[:progress_id].blank?
      @progress=Progress.find(params[:progress_id])      
    end
=end    
  end
  
  def second
    if params[:progress_id].blank?
      @user = current_user  
      @user.assign_attributes(user_params) 
      @item = Item.find(params[:item_id])     
      validations_result=validations([{type: 'presence', title: '姓名', data: user_params[:name]}, 
                                      {type: 'presence', title: '出生年月日', data: user_params[:birthday]},
                                      {type: 'presence', title: '性別', data: user_params[:gender]},
                                      {type: 'presence', title: '身分證字號', data: user_params[:id_no_TW]},                                      
                                      {type: 'presence', title: '聯絡電話',data: user_params[:phone_no]},
                                      {type: 'presence', title: '郵遞區號', data: user_params[:postal]},
                                      {type: 'presence', title: '聯絡地址-縣市', data: user_params[:county]},                                      
                                      {type: 'presence', title: '聯絡地址-鄉鎮市區', data: user_params[:district]},        
                                      {type: 'presence', title: '聯絡地址-詳細', data: user_params[:address]}])
      checkValidations(validations: validations_result, render: 'first' )     
      @user.save    
      @progress=Progress.new
      @progress.stage=2
      @progress.user = current_user           
      @progress.item = @item           
      @progress.save  
    else
      @user = current_user    
      #@user.update(user_params)     
      @progress = Progress.find(params[:progress_id])     
      @progress.stage=2
      @progress.save    
    end    
  end
  
  def third
    
  end  
  
  def indexManagement
    @progresses = @item.progresses.order('created_at DESC').paginate(page: params[:page], per_page: 30)
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
