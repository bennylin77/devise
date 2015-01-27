class ApplicationController < ActionController::Base
  
  before_action :configure_devise_permitted_parameters, if: :devise_controller?  
  rescue_from Validations::Failed, with: :validationsHandler
  rescue_from Validations::FailedRemote, with: :validationsRemoteHandler  
  protect_from_forgery with: :exception
  
  
  def validations(data)
    validation_result = [] 
    data.each do |d|
      case d[:type]
      when 'presence'     
        if d[:data].blank?
          validation_result.push({type: 'presence', message: '請填寫 '+d[:title]})
        end         
      when 'length'       
      when 'latter_than'  
         if !d[:data][:first].blank? && !d[:data][:second].blank?
           if d[:data][:first] > d[:data][:second]
            validation_result.push({type: 'latter_than', message: d[:title][:first]+' 比 '+d[:title][:second]+'晚'})                
           end 
         end      
      end
    end      
    validation_result  
  end  
  
private

  def checkValidations(hash={})
    unless hash[:validations].count==0  
      if request.xhr? 
        raise Validations::FailedRemote
      else        
        raise Validations::Failed.new(errors: hash[:validations], render: hash[:render])
      end   
    end
  end  
  
  def validationsHandler(exception)  
    flash[:error]=""
    exception.args[:errors].each do |e|
      flash[:error]=flash[:error]+e[:message]+'<br>'
    end
    
    render exception.args[:render]
  end

  def validationsRemoteHandler(exception)        
    render json: {success: false, message: exception.message }  
  end   
  
  def configure_devise_permitted_parameters
    registration_params = [:name, :email, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end  
  
  
     
end
