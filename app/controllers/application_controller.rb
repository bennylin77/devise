class ApplicationController < ActionController::Base
  rescue_from Validations::Failed, with: :ValidationsHandler
  rescue_from Validations::FailedRemote, with: :ValidationsRemoteHandler  
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
  
  def ValidationsHandler(exception)  
    flash[:error]=""
    exception.args[:errors].each do |e|
      flash[:error]=flash[:error]+e[:message]+'<br>'
    end
    
    render exception.args[:render]
  end

  def ValidationsRemoteHandler(exception)        
    render json: {success: false, message: exception.message }  
  end      
end
