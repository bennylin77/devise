module ItemsHelper
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
  		when 1
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
  
  def step_color(stage)
  	case stage
  		when 2
  			['done','under','todo','todo']
  		when 3
  			['done','done','under','todo']
  		when 4
  			['done','done','done','done']
  		else
  			['todo','todo','todo','todo']	
  	end
  end
  
end
