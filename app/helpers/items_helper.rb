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
  
  def stage_color(stage)
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
  
  def progress_status_cantext(stage)
  	case stage
  		when 2
  			"已完成填表, 請等待中心人員審核報名資格, 如審核通過, 系統將會寄送通知訊息至您的信箱"
  		when 3
  			"廠商已接受您的申請, 請完成後續的繳費程序, 如有疑問請洽 (HK)3345678"
  		when 4
  			"您已完成報名程序，廠商將會與您聯絡 謝謝～"
  		when -1
  			"您已被廠商取消報名資格"		
  	end
  end
end
