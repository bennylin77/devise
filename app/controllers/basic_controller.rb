class BasicController < ApplicationController
  before_filter :authenticate_user!     
  before_action only: [:editPeriod , :updatePeriod, :askFeedback, :sendMessage, :indexManagement, :destroy] { |c| c.PeriodCheckUser(params[:id])}  
  before_action only: [:editGroup, :updateGroup] { |c| c.GroupCheckUser(params[:id])}  
  
  before_action :set_period, only: [:indexManagement, :editPeriod, :updatePeriod, :editScore, :editFeedback, :askFeedback, :sendMessage, :destroy, :first, :second, :third, :forth, :fifth]  
  before_action :set_group, only: [:editGroup, :updateGroup]  
  
  
  def new
    @group = Group.new()
    @group.periods.build()    
    @group.periods.first.courses.build()        
    @step = 2
  end  
  
  def create
    @group = Group.new(group_params)      
    @step = 2    
    validations_result=validations([{type: 'presence', title: '名稱', data: @group.title},
                                    {type: 'presence', title: '簡介', data: @group.description},
                                    {type: 'presence', title: '招生人數', data: @group.periods.first.courses.first.no_of_users},
                                    {type: 'presence', title: '學費', data: @group.periods.first.courses.first.price},
                                    {type: 'presence', title: '報名開放時間', data: @group.periods.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.periods.first.end_at},        
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.periods.first.start_at, second: @group.periods.first.end_at }},
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' )   
    @group.periods.first.user = current_user 
    @group.periods.first.courses.first.title = @group.title
    @group.system_module = SystemModule.where(serial_code: GLOBAL_VAR['BASIC']).first
    @group.save  
    redirect_to controller: :periods, action: :createCompletion, id: @group.periods.first.id
  end 
  
  def destroy
    @period.group.destroy    
    flash[:success]="成功刪除報名"    
    redirect_to controller: 'periods', action: 'indexManagement'  
  end
  
  def indexManagement
    @progresses = @period.progresses.paginate(page: params[:page], per_page: 30)
  end

  def editPeriod  
  end 
  
  def updatePeriod
    @period.assign_attributes(period_params)
    validations_result=validations([{type: 'presence', title: '招生人數', data: @period.courses.first.no_of_users},
                                    {type: 'presence', title: '學費', data: @period.courses.first.price},
                                    {type: 'presence', title: '報名開放時間', data: @period.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @period.end_at},        
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @period.start_at, second: @period.end_at }},
                                    ])                                   
    checkValidations(validations: validations_result, render: 'editPeriod' )   
    @period.save  
    flash[:success]="成功更新班級資料"
    redirect_to controller: :basic, action: :editPeriod, id: @period.id     
  end

  def editGroup  
  end 
  
  def updateGroup
    @group.assign_attributes(group_params)
    validations_result = validations([{type: 'presence', title: '名稱', data: @group.title},
                                      {type: 'presence', title: '簡介', data: @group.description}])                                   
    checkValidations(validations: validations_result, render: 'editGroup' )   
    @group.periods.each do |p|
      c = p.courses.first    
      c.title = @group.title
      c.save!    
    end    
    @group.save      
    flash[:success]="成功更新名稱簡介"
    redirect_to controller: :basic, action: :editGroup, id: @group.id     
  end  
  
  def sendMessage
    if request.post?        
      params[:recipients].each do |r|
        System.sendMessage(user: User.find(r), subject: params[:subject], content: params[:content], attachment: params[:attachment], sender: current_user).deliver
      end    
      flash[:success]="成功寄出信件"          
      redirect_to controller: :basic, action: :sendMessage, id: @period.id     
    end
  end  
  private    
  
  def set_period
    @period = Period.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:id])
  end 
  
  def period_params
    params.require(:period).permit( :start_at, :end_at, :term, courses_attributes: [:title, :no_of_users, :price, :id])      
  end
      
  def group_params
    params.require(:group).permit(:title, :description, periods_attributes: [:start_at, :end_at, :term, courses_attributes: [:title, :no_of_users, :price, :id]])
  end    
end