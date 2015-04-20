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
      when 'id_no_TW'  
         unless idCheck(d[:data])
          validation_result.push({type: 'presence', message: d[:title]+' 格式錯誤'})                 
         end       
      end
    end      
    validation_result  
  end  

  def checkValidations(hash={})
    unless hash[:validations].count==0  
      if request.xhr? 
        raise Validations::FailedRemote
      else        
        raise Validations::Failed.new(errors: hash[:validations], render: hash[:render])
      end   
    end
  end   
  
  def ModuleCheckUser(id, role)
    unless SystemModule.where(id: id).first == nil      
      if SystemModule.find(id).module_user_lists.where(user_id: current_user.id).first.role != role      
        flash["error"]="您沒有權限"
        redirect_to root_url          
      end  
    else
      flash["error"]="項目不存在"
      redirect_to root_url        
    end     
  end
  
  def GroupCheckUser(id)
    unless Group.where(id: id).first == nil      
      if Group.find(id).items.where(user_id: current_user.id).first == nil      
        flash["error"]="您沒有權限"
        redirect_to root_url          
      end  
    else
      flash["error"]="項目不存在"
      redirect_to root_url        
    end 
  end

  def ProgressCheckItemUser(id)
    unless Progress.where(id: id).first == nil      
      if Progress.find(id).item.user != current_user      
        flash["error"]="您沒有權限"
        redirect_to root_url          
      end  
    else
      flash["error"]="項目不存在"
      redirect_to root_url        
    end 
  end
    
  [:Item, :Progress].each do |model|
    class_eval %Q{
      def #{model}CheckUser(id)
       unless #{model}.where(id: id).first == nil
         if #{model}.find(id).user != current_user
            flash["error"]="您沒有權限"
            redirect_to root_url          
         end  
       else
        flash["error"]="項目不存在"
        redirect_to root_url        
       end    
      end
    }
  end
  
private

  def validationsHandler(exception)  
    flash[:error]=""
    exception.args[:errors].each do |e|
      flash.now[:error]=flash.now[:error]+e[:message]+'<br>'
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
  
  def idCheck(id)
    return false unless id =~ /\A[A-Z]\d{9}\z/
    map = {
      'A' => [1, 0], 'B' => [1, 1], 'C' => [1, 2], 'D' => [1, 3], 'E' => [1, 4], 'F' => [1, 5], 'G' => [1, 6], 'H' => [1, 7], 'I' => [3, 4],
      'J' => [1, 8], 'K' => [1, 9], 'L' => [2, 0], 'M' => [2, 1], 'N' => [2, 2], 'O' => [3, 5], 'P' => [2, 3], 'Q' => [2, 4], 'R' => [2, 5],
      'S' => [2, 6], 'T' => [2, 7], 'U' => [2, 8], 'V' => [2, 9], 'W' => [3, 2], 'X' => [3, 0], 'Y' => [3, 1], 'Z' => [3, 3]
    } 
    multiplier = [1, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1]       
   
    chars = id.chars
    numbers = map[chars.shift] + chars.map!(&:to_i)
    sum, i = 0, 0
    while i < 11
      sum += numbers[i] * multiplier[i]
      i += 1
    end
    sum % 10 == 0
  end  
     
end
