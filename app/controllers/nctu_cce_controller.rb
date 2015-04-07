class NctuCceController < ApplicationController
  before_filter :authenticate_user! 
  before_action only: [:editItem , :updateItem, :sendMessage, :indexManagement] { |c| c.ItemCheckUser(params[:id])}  
  before_action only: [:editGroup, :updateGroup] { |c| c.GroupCheckUser(params[:id])}  
  before_action only: [:verified] { |c| c.ProgressCheckItemUser(params[:id])}  

  before_action :set_step, only: [:new, :create]
  before_action :set_item, only: [:show, :editItem, :updateItem, :destroy, :indexManagement, :sendMessage, :first]
  before_action :set_group, only: [:editGroup, :updateGroup]  
  before_action :set_progress, only: [:showProgress, :verified, :cancel] 
     
  def new
    @group = Group.new( module: params[:module])
    @group.items.build()    
    @step = 2
  end
  
  def create
    @group = Group.new(group_params)      
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description},
                                    {type: 'presence', title: '報名人數', data: @group.items.first.no_of_user},
                                    {type: 'presence', title: '金額', data: @group.items.first.price},
                                    {type: 'presence', title: '報名開放時間', data: @group.items.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.items.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_start_at, second: @group.items.first.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' )   
    @group.items.first.user = current_user 
    @group.save  
    redirect_to controller: :items, action: :createCompletion, id: @group.items.first.id
  end 
  
  def editItem  
  end 
  
  def updateItem
    @item.assign_attributes(item_params)
    validations_result=validations([{type: 'presence', title: '報名人數', data: @item.no_of_user},
                                    {type: 'presence', title: '金額', data: @item.price},
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
  
  def first
    @user = current_user   
    @step = 1
  end
  
  def second
    if params[:progress_id].blank?
      @user = current_user  
      @user.assign_attributes(user_params) 
      @item = Item.find(params[:item_id])    
      @step = 1       
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
      @step = 2          
      @user.save    
      if @item.progresses.count < @item.no_of_user or @item.waiting_available
        @progress=Progress.new
        @progress.stage=2
        @progress.user = current_user           
        @progress.item = @item     
        @progress.save                 
        #waiting
        if ( !@item.waiting_start and @item.progresses.count>=@item.no_of_user ) or @item.waiting_start 
            @item.waiting_start=true 
            unless @item.progresses.count==@item.no_of_user 
              @item.no_of_waiting_user+= 1        
              @progress.waiting_no=@item.no_of_waiting_user
              @progress.waiting=true   
            end                     
        end  
        @item.save           
        @progress.save   
      end               
    else
      @user = current_user     
      @progress = Progress.find(params[:progress_id])     
      @progress.stage=2
      @progress.save   
      @step = 2       
    end    
  end
  
  def third
    @step = 3     
    @progress = Progress.find(params[:progress_id])      
  end  

  def verified
    if @progress.verified
      @progress.verified=false
      @progress.stage=-1
      @progress.reason = params[:reason]
      if @progress.vaccount
        @progress.vaccount.active = false 
        @progress.vaccount.save!
      end
      @progress.save!
      flash[:alert]="已取消通過 "+@progress.user.name+" 的報名"
    else
      @progress.verified=true 
      @progress.payment = params[:payment].to_f
      @progress.create_vaccount if @progress.payment > 0
      @progress.stage= (@progress.payment > 0) ? 3 : 4  
      @progress.save!    
      flash[:success]="已審核通過 "+@progress.user.name+" 的報名"
    end
    System.verified_result_send(@progress)
    redirect_to controller: 'nctu_cce', action: 'showProgress', id: @progress.id
  end  
  
  def indexManagement
    @progresses = @item.progresses.paginate(page: params[:page], per_page: 30)
  end  
  
  def showProgress
  end
  
  def cancel
    @progress.destroy!
    redirect_to controller: 'items', action: 'progress', finished: false   
  end
  
  def check_account
  	if request.post?
  		vacc = params[:vacc]
  		vc = Vaccount.new
  		vc.check_account(vacc)
  		vc.vacc = vacc
  		vc.update_status
  		@row = "<tr><td>#{vacc}</td>"
  		@row += "<td>#{vc.status["res"]["desc"]}</td>"
  		@row += "<td>#{vc.status["Amount"]}</td>"
  		@row += "<td>#{vc.status["PayChnl"]}</td></tr>"
  	end
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
    params.require(:user).permit(:name, :birthday, :gender, :id_no_TW, :phone_no, :address, :postal, :county, :district)      
  end

  def group_params
    params.require(:group).permit(:module, :title, :description, items_attributes: [:verification_code, :no_of_user, :price,
                                  :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, :term, :waiting_available])
  end  
end
