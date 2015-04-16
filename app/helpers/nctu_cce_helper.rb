module NctuCceHelper  
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
