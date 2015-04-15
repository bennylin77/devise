namespace :vaccount do

  desc "update status"
  task :update_status => :environment do
     Vaccount.where(active: true).each do |vacc|
     	res = vacc.update_status
     	if res==-1 # 伺服器維修中
				p "can't connect to esun server "
				return 
			end
     	#p vacc.status.inspect
     	if vacc.status["code"].to_i!=1000 and vacc.status["Amount"].to_f == vacc.progress.payment.to_f
     		vacc.progress.stage = 4 #vacc.progress.item.group.module
     		vacc.progress.save!
     		vacc.active = false
     	end
     	vacc.save!
     end
     
  end
  
  desc "test"
  task :test => :environment do
  		data = "95306123123441"
    	vc = Vaccount.new
  		vc.check_account(data)
  		vc.vacc = data
  		res = vc.update_status
  		return if res == -1
  		p vc.status
  end
end