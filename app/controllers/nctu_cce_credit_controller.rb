class NctuCceCreditController < ApplicationController
  before_filter :authenticate_user!   
  before_action :set_new_step, only: [:new, :newCourses, :create]
  
  
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
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_strat_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_strat_at, second: @group.items.first.payment_end_at }}                                    
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
                                    {type: 'presence', title: '繳費開放時間', data: @group.items.first.payment_strat_at},
                                    {type: 'presence', title: '繳費結束時間', data: @group.items.first.payment_end_at},
                                    {type: 'latter_than', title: { first: '報名開放時間', second: '報名結束時間' }, data: { first: @group.items.first.start_at, second: @group.items.first.end_at }},
                                    {type: 'latter_than', title: { first: '繳費開放時間', second: '繳費結束時間' }, data: { first: @group.items.first.payment_strat_at, second: @group.items.first.payment_end_at }}                                    
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

  private
  
  def set_new_step
    @step = params[:step]
  end  
  
  def group_params
    params.require(:group).permit(:module, :title, :description, items_attributes: [:verification_code, :no_of_user, :price,
                                  :start_at, :end_at, :payment_strat_at, :payment_end_at, :school_year, :semester, :term, :waiting_available])
  end      
end
