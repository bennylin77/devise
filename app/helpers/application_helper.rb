module ApplicationHelper
  
  def host
    "http://register.ac-experts.com.tw/"
  end
    
  def alert_class_for(flash_type)
    { :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end  
  
  def stepProgress(hash={})
    if hash[:step].to_i == hash[:step_now].to_i
      'under'
    elsif hash[:step].to_i > hash[:step_now].to_i 
      'todo'
    else
      'done'  
    end         
  end   
  
  def showBlank(s)
    if s.blank?
      '--'
    else  
      simple_format( s, {}, wrapper_tag: "span")
    end
  end  
end
