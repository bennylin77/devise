# encoding: utf-8
class System < ActionMailer::Base
  default from: "EasyRegister 報名系統 <system@easyregister.tw>"
  helper ApplicationHelper  
  
  def sendMessage(hash={}) 
    unless hash[:attachment].nil?
      hash[:attachment].each do |a|
        file=a
        attachments[file.original_filename] = File.open(file.path, 'rb'){|f| f.read}  
      end
    end    
    @user = hash[:user]
    @content = hash[:content]
    @sender = hash[:sender]
    @progress = hash[:progress]
    mail( to: @user.email, subject: hash[:subject])    
  end 
  
  def sendVerifyNotification(hash={}) 
    @user = hash[:user]
    @progress=hash[:progress]
    subject = "EasyRegister #{@progress.period.group.title} 報名審核"    
    mail( to: @user.email, subject: subject)    
  end   

  def sendUnverified(hash={})
    @user = hash[:user]
    @progress=hash[:progress]    
    subject = "EasyRegister #{@progress.period.group.title} 審核不通過/取消資格"
    mail( to: @user.email, subject: subject, cc: @progress.user.email)
  end  
  
	def sendVerified(hash={})
    @user = hash[:user]
    @progress=hash[:progress] 
    subject = "EasyRegister #{@progress.period.group.title} 審核通過"
		mail( to: @user.email, subject: subject, cc: @progress.user.email)
	end	 
	
	def sendFeedbackAsking(hash={})
    @user = hash[:user]
    @progress=hash[:progress] 
    subject = "EasyRegister #{@progress.period.group.title} 教學反映問卷邀請"
    mail( to: @user.email, subject: subject)	  
	end
	
	def sendGetMoney(hash={})
    @progress=hash[:progress] 
    subject = "EasyRegister #{@progress.period.group.title} 匯款成功"
		mail( to: @progress.user.email, subject: subject)
	end
	
	def sendGetMoneyToManager(hash={})
		@user = hash[:user]
		@progress=hash[:progress] 
		subject = "EasyRegister #{@progress.user.name} 已匯款"
		mail( to: @user.email, subject: subject)
	end
end
