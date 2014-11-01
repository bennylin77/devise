module ApplicationHelper
  
  def newStepProgress(hash={})
    case hash[:step]
    when 1
      if params[:controller]=='items'
        params[:action]=='new' ? 'under' : 'done'
      else
        'done'
      end 
    when 2
      if params[:controller]!='items'
        'under'
      else
        params[:action]=='new' ? 'todo' : 'done'
      end                 
    when 3
      if params[:controller]=='items'
        params[:action]=='createCompletion' ? 'done' : 'todo'
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
