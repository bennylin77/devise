module ApplicationHelper
  
  def host
    "http://instant.tw"
  end
    
  def alert_class_for(flash_type)
    { :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end  
  
  def newStepProgress(hash={})
    if hash[:step].to_i == hash[:step_now].to_i
      'under'
    elsif hash[:step].to_i > hash[:step_now].to_i 
      'todo'
    else
      'done'  
    end         
  end   
  
end
