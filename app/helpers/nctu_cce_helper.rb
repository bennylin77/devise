module NctuCceHelper
  def NCTUCCEStepProgress(hash={})
    case hash[:step]
    when 1
      if params[:controller]=='items'
        'done'
      else
        params[:action]=='first' ? 'under' : 'done'
      end 
    when 2
      if params[:controller]=='items'
        'done'
      else
        params[:action]=='new' ? 'under' : 'done'
      end                
    when 3
      if params[:controller]=='items'
        params[:action]=='createCompletion' ? 'done' : 'todo'
      else
        'todo'
      end       
    end      
  end
end
