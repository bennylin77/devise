class NctuCceController < ApplicationController
  before_filter :authenticate_user! 
  before_action only: [:editItem , :updateItem, :sendMessage, :indexManagement] { |c| c.ItemCheckUser(params[:id])}  
  before_action only: [:cancel] { |c| c.ProgressCheckUser(params[:id])}   
  before_action only: [:editGroup, :updateGroup] { |c| c.GroupCheckUser(params[:id])}  
  before_action only: [:destroyProgress, :verified] { |c| c.ProgressCheckItemUser(params[:id])}  

  before_action :set_step, only: [:new, :create]
  before_action :set_item, only: [:show, :editItem, :updateItem, :destroy, :indexManagement, :sendMessage, :first, :second, :third, :forth]
  before_action :set_group, only: [:editGroup, :updateGroup]  
  before_action :set_progress, only: [:showProgress, :verified, :cancel, :destroyProgress] 
     
  def new
    @group = Group.new( module: params[:module])
    @group.items.build()    
    @step = 2
  end
  
  def create
    @group = Group.new(group_params)      
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description},
                                    {type: 'presence', title: '招生人數', data: @group.items.first.no_of_user},
                                    {type: 'presence', title: '學費', data: @group.items.first.price},
                                    {type: 'presence', title: '報名開放時間', data: @group.items.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.items.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_start_at, second: @group.items.first.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' )   
    @group.items.first.user = current_user 
    @group.system_module = SystemModule.where(serial_code: GLOBAL_VAR['NCTU_CCE']).first
    @group.save  
    redirect_to controller: :items, action: :createCompletion, id: @group.items.first.id
  end 
  
  def editItem  
  end 
  
  def updateItem
    @item.assign_attributes(item_params)
    validations_result=validations([{type: 'presence', title: '招生人數', data: @item.no_of_user},
                                    {type: 'presence', title: '學費', data: @item.price},
                                    {type: 'presence', title: '報名開放時間', data: @item.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @item.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @item.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @item.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @item.start_at, second: @item.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @item.payment_start_at, second: @item.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'editItem' )   
    @item.save  
    flash[:success]="成功更新基本資料"
    redirect_to controller: :nctu_cce, action: :indexManagement, id: @item.id     
  end
  
  def editGroup  
  end 
  
  def updateGroup
    @group.assign_attributes(group_params)
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description}])                                   
    checkValidations(validations: validations_result, render: 'editGroup' )   
    @group.save  
    flash[:success]="成功更新名稱簡介"
    redirect_to controller: :nctu_cce, action: :indexManagement, id: @group.items.first.id     
  end  

  def sendMessage
    if request.post?        
      params[:recipients].each do |r|
        System.sendMessage(user: User.find(r), subject: params[:subject], content: params[:content], attachment: params[:attachment]).deliver
      end    
      flash[:success]="成功寄出信件"          
      redirect_to controller: :nctu_cce, action: :indexManagement, id: @item.id     
    end
  end  
 # ------------ booking --------------# 
  def cancel
=begin    
    if @progress.item.waiting_start
      @progress.item.no_of_waiting_user-= 1
      if @progress.item.no_of_waiting_user == 0
        @progress.item.waiting_start = false      
      end
      @progress.item.save!         
    end    
=end    
    @progress.destroy    
    flash[:success]="成功退出報名"    
    redirect_to controller: 'items', action: 'progress'   
  end
   
  def first
    @user = current_user     
    progress = @item.progresses.where(user_id: current_user.id).first
    if progress.blank?
      if ( @item.progresses.count < @item.no_of_user ) or @item.waiting_available
        @progress=Progress.new
        @progress.stage=1
        @progress.user = current_user           
        @progress.item = @item     
        @progress.save                 
        #waiting
        if ( !@item.waiting_start and @item.progresses.count == @item.no_of_user ) or @item.waiting_start 
          @item.waiting_start = true 
          if @item.progresses.count > @item.no_of_user 
            @item.no_of_waiting_user+= 1        
            @progress.waiting_no = @item.no_of_waiting_user
            @progress.waiting = true   
          end                     
        end  
        @item.save           
        @progress.save   
      end               
    else
      @progress = progress        
    end  
    @step = 1  
  end
  
  def second    
    if request.post?
      user = current_user  
      user.assign_attributes(user_params)  
      @step = 1       
      @progress = @item.progresses.where(user_id: current_user.id).first            
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
      user.save  
      @progress.stage = 2
      @progress.reason = ''
      @progress.save  
      System.sendVerifyNotification(user: @progress.item.user, progress: @progress).deliver        
    else
      @progress = @item.progresses.where(user_id: current_user.id).first          
    end     
    @step = 2      
  end
  
  def third
    @step = 3     
    @progress = @item.progresses.where(user_id: current_user.id).first     
  end 
  
  def forth
    @step = 4       
    @progress = @item.progresses.where(user_id: current_user.id).first         
  end   

  def verified
    if params[:verify] == 'false'
      @progress.verified = false
      @progress.stage = 1
      @progress.reason = params[:reason]
      if @progress.vaccount
        @progress.vaccount.active = false 
        @progress.vaccount.save!
      end
      @progress.save!
      flash[:alert]="審核不通過/取消資格 "+@progress.user.name+" 的報名"
      System.sendUnverified(user: @progress.user, progress: @progress).deliver   
    else
      @progress.verified=true 
      @progress.payment = params[:payment].to_f
      @progress.create_vaccount if @progress.payment > 0
      @progress.stage= (@progress.payment > 0) ? 3 : 4  
      @progress.save!    
      flash[:success]="已審核通過 "+@progress.user.name+" 的報名"
      System.sendVerified(user: @progress.user, progress: @progress).deliver   
    end
    redirect_to controller: 'nctu_cce', action: 'showProgress', id: @progress.id
  end  
  
  def destroyProgress
    item = @progress.item
    @progress.destroy    
    flash[:success]="成功刪除報名"    
    redirect_to controller: 'nctu_cce', action: 'indexManagement', id: item.id       
  end
  
  def indexManagement
    @progresses = @item.progresses.paginate(page: params[:page], per_page: 30)
  end  
  
  def showProgress
  end
  
 
  private
  def set_step
    @step = params[:step]
  end  
    
  def set_item
    @item = Item.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:id])
  end   
    
  def set_progress
    @progress = Progress.find(params[:id])     
  end
    
  def item_params
    params.require(:item).permit(:verification_code, :no_of_user, :price,
                                 :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, :term, :waiting_available)      
  end
    
  def user_params
    params.require(:user).permit(:name, :birthday, :gender, :id_no_TW, :phone_no, :address, 
                                 :postal, :county, :district, :name_en, :hightest_education_school, :hightest_education_department,
                                 :work_name, :work_title, :work_phone_no, :work_county, :work_district, :work_postal, :work_address)      
  end

  def group_params
    params.require(:group).permit(:title, :description, items_attributes: [:verification_code, :no_of_user, :price,
                                  :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, :term, :waiting_available])
  end  
end
