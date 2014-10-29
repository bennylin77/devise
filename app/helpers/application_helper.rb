module ApplicationHelper
  
  def newStepProgress(hash={})
    case hash[:step]
    when 1
      if params[:controller]=='items'
        if params[:action]=='new'
          'under'
        else
          'done'
        end
      else
        'done'
      end 
    when 2
      if params[:controller]!='items'
        'under'
      else
        if params[:action]=='new'
          'todo'
        else
          'done'
        end
      end                 
    when 3
      if params[:controller]=='items'
        if params[:action]=='createCompletion'
          'done'
        else
          'todo'
        end
      else
        'todo'
      end       
    end      
  end
  
  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end  
end
