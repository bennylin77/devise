module ItemsHelper
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
