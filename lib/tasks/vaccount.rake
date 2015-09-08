namespace :vaccount do

  desc "update status"
  task :update_status => :environment do
     Vaccount.where(active: true).each do |vacc|
			next if vacc.progress.blank? # 防髒資料
     #	p vacc.vacc
     	res = vacc.update_status
			if !vacc.is_closed
        vacc.syncMssqlPurpose if vacc.purpose.present?
				vacc.syncMssqlPaidByAndAck if vacc.paid_by.present?
			end
     	if vacc.money.to_f >= vacc.progress.payment.to_f and vacc.progress.stage < 4
				p "new pass #{vacc.vacc}"
				vacc.progress.stage = 4 #vacc.progress.item.group.module
     		vacc.progress.save!
     		vacc.active = false # 已完成繳費（滿足金額）  設false避免再檢查
				System.sendGetMoney(:progress=>vacc.progress).deliver # inform user
				System.sendGetMoneyToManager(:user=>vacc.progress.user, :progress=>vacc.progress).deliver # inform manager(item.user)
     	end
     	vacc.save!
     end
     
  end
	
  desc "update purpose,PaidBy, Ack for bug on 20150829"
  task :update_20150829 => :environment do
		Vaccount.where(active: false).each do |vacc|
			vacc.syncMssqlPaidByAndAck if vacc.paid_by.present?
			vacc.syncMssqlPurpose if vacc.purpose.present?
		end
  end
	
  desc "test"
  task :test => :environment do
  	vacc=Vaccount.create(active: true,vacc: "95306672277054")
		vacc.update_status
		puts vacc.to_json
		vacc.destroy
  end
end
