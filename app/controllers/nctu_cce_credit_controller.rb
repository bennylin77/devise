class NctuCceCreditController < ApplicationController
  before_filter :authenticate_user!   
  
  before_action :set_new_step, only: [:new, :newCourses, :create]
  before_action :set_item, only: [:indexManagement, :editItem, :sendMessage, :editCourses]  
  before_action :set_group, only: [:editGroup]  
    
  def new
    @group = Group.new( module: params[:module])
    @group.items.build()        
  end
  
  def newCourses
    @group = Group.new(group_params)      
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description},
                                    {type: 'presence', title: '報名開放時間', data: @group.items.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.items.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_start_at, second: @group.items.first.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' ) 
    @step = 3      
  end
  
  def create
    @group = Group.new(group_params)      
    @title = params[:title]
    @price = params[:price]
    @no_of_user = params[:no_of_user]    
    
    validations_result=validations([{type: 'presence', title: '班級名稱', data: @group.title},
                                    {type: 'presence', title: '班級簡介', data: @group.description},
                                    {type: 'presence', title: '報名開放時間', data: @group.items.first.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @group.items.first.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_start_at, second: @group.items.first.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'new' )       
    params[:title].each_with_index do |t, i|
      validations_result=validations([{type: 'presence', title: '課程名稱', data: t},     
                                      {type: 'presence', title: '學費', data: params[:price][i]},   
                                      {type: 'presence', title: '招生人數', data: params[:no_of_user][i]}                                                                                   
                                      ])        
      checkValidations(validations: validations_result, render: 'newCourses' )                                           
    end

    @group.items.first.user = current_user 
    @group.save      
    params[:title].each_with_index do |t, i|
      @group.items.first.sub_items.create(title: t, price: params[:price][i], no_of_user: params[:no_of_user][i])    
    end   
    redirect_to controller: :items, action: :createCompletion, id: @group.items.first.id  
  end  

  def indexManagement
    @progresses = @item.progresses.paginate(page: params[:page], per_page: 30)
  end  

  def sendMessage 
    if request.post?       
      params[:recipients].each do |r|
        System.sendMessage(user: User.find(r), subject: params[:subject], content: params[:content], attachment: params[:attachment]).deliver
      end 
      redirect_to controller: :nctu_cce_credit, action: :indexManagement, id: @item.id     
    end
  end

  def editItem  
  end 
  
  def updateItem
    @item=Item.find(params[:item][:id])
    @item.assign_attributes(item_params)
    validations_result=validations([{type: 'presence', title: '報名開放時間', data: @item.start_at},                                      
                                    {type: 'presence', title: '報名結束時間', data: @item.end_at},        
                                    {type: 'presence', title: '繳費開放時間', data: @item.payment_start_at},
                                    {type: 'presence', title: '繳費結束時間', data: @item.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @item.start_at, second: @item.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @item.payment_start_at, second: @item.payment_end_at }}                                    
                                    ])                                   
    checkValidations(validations: validations_result, render: 'editItem' )   
    @item.save  
    flash[:success]="成功更新基本資料"
    redirect_to controller: :nctu_cce_credit, action: :indexManagement, id: @item.id     
  end  
  
  def editGroup  
  end 
  
  def updateGroup
    @group=Group.find(params[:group][:id])
    @group.assign_attributes(group_params)
    validations_result=validations([{type: 'presence', title: '課程名稱', data: @group.title},
                                    {type: 'presence', title: '課程簡介', data: @group.description}])                                   
    checkValidations(validations: validations_result, render: 'editGroup' )   
    @group.save  
    flash[:success]="成功更新名稱簡介"
    redirect_to controller: :nctu_cce_credit, action: :indexManagement, id: @group.items.first.id     
  end   
  
  def editCourses     
  end
  
  def updateCourses
    
  end
  
  private

  def set_item
    @item = Item.find(params[:id])
  end
  
  def set_new_step
    @step = params[:step]
  end  
  
  def set_group
    @group = Group.find(params[:id])
  end   
  
  def item_params
    params.require(:item).permit( :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, sub_items_attributes: [:title, :no_of_user, :price])      
  end
  
  def group_params
    params.require(:group).permit(:module, :title, :description, items_attributes: [:verification_code, :no_of_user, :price,
                                  :start_at, :end_at, :payment_start_at, :payment_end_at, :school_year, :semester, :term, :waiting_available])
  end      
end
