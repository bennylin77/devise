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
      when 5
        "評價" 			
  		when -1
  			"已取消報名"
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
  
  [:nctu_cce_feedback_1_1, :nctu_cce_feedback_1_2, :nctu_cce_feedback_1_3, :nctu_cce_feedback_1_4, :nctu_cce_feedback_1_5, 
   :nctu_cce_feedback_2_1, :nctu_cce_feedback_2_2, :nctu_cce_feedback_2_3, :nctu_cce_feedback_2_4, :nctu_cce_feedback_2_5,
   :nctu_cce_feedback_2_6, :nctu_cce_feedback_2_7, :nctu_cce_feedback_2_8, :nctu_cce_feedback_2_9, :nctu_cce_feedback_2_10,
   :nctu_cce_feedback_2_11].each do |f|
    class_eval %Q{  
    def #{f}FeedbackStatistics(item)
      result = Array.new(12, 0.0)
      temp_data = Array.new(6, 0.0) 
      item.progresses.where(stage: 4, feedback_done: true).each do |p| 
        result[0] =result[0] + p.#{f}
        case p.#{f}
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
          result[6] = result[6] + p.#{f}
        when 1
          temp_data[1] = temp_data[1] + 1    
          result[7] = result[7] + p.#{f}     
        when 2            
          temp_data[2] = temp_data[2] + 1    
          result[8] = result[8] + p.#{f}                  
        end
        case p.nctu_cce_feedback_4_4
        when 0
          temp_data[3] = temp_data[3] + 1
          result[9] = result[9] + p.#{f}
        when 1
          temp_data[4] = temp_data[4] + 1    
          result[10] = result[10] + p.#{f}          
        when 2            
          temp_data[5] = temp_data[5] + 1    
          result[11] = result[11] + p.#{f}                   
        end      
      end        
      for i in 0..5
        if temp_data[i] != 0
          result[i+6] = result[i+6]/temp_data[i] 
        end
        result[i+6] = result[i+6].round(2).to_s+' 分' 
      end     
      result[0] = result[0] / item.progresses.where(feedback_done: true).count.to_f 
      result[0] = result[0].round(2).to_s+' 分'      
      for i in 1..5
          result[i] = (result[i] / item.progresses.where(feedback_done: true).count.to_f) * 100 
          result[i] = result[i].round(2).to_s+'%'
      end 
      result   
    end  
    }
  end    

  [:nctu_cce_feedback_4_1, :nctu_cce_feedback_4_2, :nctu_cce_feedback_4_3, :nctu_cce_feedback_4_4, :nctu_cce_feedback_4_5].each do |f|
    class_eval %Q{  
    def #{f}FeedbackStatistics(item)
      result = Array.new(4, 0)   
      item.progresses.where(stage: 4, feedback_done: true).each do |p|           
        case p.#{f}
        when 0
          result[0] = result[0] + 1
        when 1
          result[1] = result[1] + 1  
        when 2
          result[2] = result[2] + 1
        when 3
          result[3] = result[3] + 1                         
        end      
      end  
      for i in 0..3
          result[i] = result[i].to_s+' 人'        
      end  
      result  
    end
    }
  end    
  
end
