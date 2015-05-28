module NctuCceCreditHelper
 
  [:nctu_cce_feedback_1_1, :nctu_cce_feedback_1_2, :nctu_cce_feedback_1_3, :nctu_cce_feedback_1_4, :nctu_cce_feedback_1_5, 
   :nctu_cce_feedback_2_1, :nctu_cce_feedback_2_2, :nctu_cce_feedback_2_3, :nctu_cce_feedback_2_4, :nctu_cce_feedback_2_5,
   :nctu_cce_feedback_2_6, :nctu_cce_feedback_2_7, :nctu_cce_feedback_2_8, :nctu_cce_feedback_2_9, :nctu_cce_feedback_2_10,
   :nctu_cce_feedback_2_11].each do |f|
    class_eval %Q{  
    def #{f}SubFeedbackStatistics(period, course_id)
      result = Array.new(12, 0.0)
      temp_data = Array.new(6, 0.0) 
      user_count = 0
      period.progresses.where(stage: 5, feedback_done: true).each do |p|     
        p.registered_courses.each do |r_c| 
          if r_c.course.id == course_id           
            user_count = user_count + 1    
            result[0] =result[0] + r_c.#{f}
            case r_c.#{f}
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
            case r_c.nctu_cce_feedback_4_1
            when 0
              temp_data[0] = temp_data[0] + 1
              result[6] = result[6] + r_c.#{f}
            when 1
              temp_data[1] = temp_data[1] + 1    
              result[7] = result[7] + r_c.#{f}     
            when 2            
              temp_data[2] = temp_data[2] + 1    
              result[8] = result[8] + r_c.#{f}                  
            end
            case r_c.nctu_cce_feedback_4_4
            when 0
              temp_data[3] = temp_data[3] + 1
              result[9] = result[9] + r_c.#{f}
            when 1
              temp_data[4] = temp_data[4] + 1    
              result[10] = result[10] + r_c.#{f}          
            when 2            
              temp_data[5] = temp_data[5] + 1    
              result[11] = result[11] + r_c.#{f}                   
            end            
          end   
        end   
      end         
      for i in 0..5
        if temp_data[i] != 0
          result[i+6] = result[i+6]/temp_data[i] 
        end
        result[i+6] = result[i+6].round(2).to_s+' 分' 
      end     
      result[0] = result[0] / user_count.to_f 
      result[0] = result[0].round(2).to_s+' 分'      
      for i in 1..5
          result[i] = (result[i] / user_count.to_f) * 100 
          result[i] = result[i].round(2).to_s+'%'
      end 
      result   
    end  
    }
  end    

  [:nctu_cce_feedback_4_1, :nctu_cce_feedback_4_2, :nctu_cce_feedback_4_3, :nctu_cce_feedback_4_4, :nctu_cce_feedback_4_5].each do |f|
    class_eval %Q{  
    def #{f}SubFeedbackStatistics(period, course_id)
      result = Array.new(4, 0)   
      period.progresses.where(stage: 5, feedback_done: true).each do |p| 
        p.registered_courses.each do |r_c| 
          if r_c.course.id == course_id                    
            case r_c.#{f}
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
