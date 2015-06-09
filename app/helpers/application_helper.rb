module ApplicationHelper
   
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
  
  def waitingFunction(code)
    if code == GLOBAL_VAR['NCTU_CCE']
      true
    else
      false  
    end
  end
  
  def controllerOptions
    [['basic', GLOBAL_VAR['BASIC']],
     ['nctu_cce', GLOBAL_VAR['NCTU_CCE']],
     ['nctu_cce_credit', GLOBAL_VAR['NCTU_CCE_credit']],    
     ['nctu_cce_camp', GLOBAL_VAR['NCTU_CCE_camp']]]
  end  

  def stageOptions
    [['first', 1],
    ['second', 2],
    ['third', 3],
    ['forth', 4],
    ['fifth', 5]]
  end    
  
  def semesterOptions
    [["上學期", 1], ["寒假", -1], ["下學期", 2], ["暑假", -2]]
  end  

  def sourceOptions
    [['網路', GLOBAL_VAR['SOURCE_WEBSITE']],
    ['海報簡章', GLOBAL_VAR['SOURCE_POSTER']],
    ['EMAIL', GLOBAL_VAR['SOURCE_EMAIL']],
    ['教授', GLOBAL_VAR['SOURCE_PROFESSOR']],
    ['其他', GLOBAL_VAR['SOURCE_OTHERS']]]
  end   
  
  def stageColor(progress)
    
    if progress.verified
      "success"
    else
      "default"       
    end   
  end
  
end
