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
        case params[:action]
        when 'first'
          'todo'
        when 'second'
          'under'
        when 'third'    
          'done'
        end  
      end                
    when 3
      if params[:controller]=='items'
        'done'
      else
        case params[:action]
        when 'first'
          'todo'
        when 'second'
          'todo'
        when 'third'    
          'under'
        end  
      end     
    end      
  end
  
  def stage_text(stage)
  	case stage 		
  		when 2
  			"待審核"
  		when 3
  			"待繳費"
  		when 4
  			"完成報名"
  		when -1
  			"已取消報名"
  	end
  end
end
