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
  
  def active(hash={}) 
    if current_page?(controller: hash[:controller], action: hash[:action])
      "class='active'".html_safe     
    end
  end

  def moduleOptions
    [['交大推廣教育中心培訓班', GLOBAL_VAR['NCTU_CCE']],
     ['交大推廣教育中心學分班', GLOBAL_VAR['NCTU_CCE_credit']],    
     ['交大推廣教育中心營隊', GLOBAL_VAR['NCTU_CCE_camp']]]
  end  
  
  def controllerOptions
    [['nctu_cce', GLOBAL_VAR['NCTU_CCE']],
     ['nctu_cce_credit', GLOBAL_VAR['NCTU_CCE_credit']],    
     ['nctu_cce_camp', GLOBAL_VAR['NCTU_CCE_camp']]]
  end  

  def stageOptions
    [['first', 1],
    ['second', 2],
    ['third', 3],
    ['forth', 4]]
  end    
  
  def stageColor(stage)
    case stage
      when 1 # 待審核
        "default"       
      when 2 # 待審核
        "default"
      when 3 # 待繳費
        "warning"
      when 4 # 報名完成
        "success"
      when -1 # 被取消
        "danger"  
    end  
  end
  
end
