module NctuCceHelper  
  def stageText(stage)
  	case stage 		
      when 1
        "填表中"  	  
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
  
  def feedbackStatistics(item)
    result = Array.new(12, 0.0)
    temp_data = Array.new(6, 0.0) 
    
    item.progresses.where(stage: 4, feedback_done: true).each do |p| 
      result[0] =result[0] + p.nctu_cce_feedback_1_1 
      case p.nctu_cce_feedback_1_1
      when 5
        result[1] =result[1] + 1
      when 4
        result[2] =result[2] + 1      
      when 3
        result[3] =result[3] + 1      
      when 2
        result[4] =result[4] + 1      
      when 1     
        result[5] =result[5] + 1                         
      end
      
      case p.nctu_cce_feedback_4_1
      when 0
        temp_data[0] = temp_data[0] + 1
        result[6] = result[6] + p.nctu_cce_feedback_1_1
      when 1
        temp_data[1] = temp_data[1] + 1    
        result[7] = result[7] + p.nctu_cce_feedback_1_1          
      when 2            
        temp_data[2] = temp_data[2] + 1    
        result[8] = result[8] + p.nctu_cce_feedback_1_1                    
      end

      case p.nctu_cce_feedback_4_2
      when 0
        temp_data[3] = temp_data[3] + 1
        result[9] = result[9] + p.nctu_cce_feedback_1_1
      when 1
        temp_data[4] = temp_data[4] + 1    
        result[10] = result[10] + p.nctu_cce_feedback_1_1          
      when 2            
        temp_data[5] = temp_data[5] + 1    
        result[11] = result[11] + p.nctu_cce_feedback_1_1                    
      end      
    end     
    
    for i in 0..5
      if temp_data[i] != 0
        result[i+6] = result[i+6]/temp_data[i] 
      end
    end  
    
    result[0] = result[0] / item.progresses.where(feedback_done: true).count.to_f 
    for i in 1..5
        result[i] = (result[i] / item.progresses.where(feedback_done: true).count.to_f) * 100 
    end
    
    result   
  end
  
end
