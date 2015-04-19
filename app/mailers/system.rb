# encoding: utf-8
class System < ActionMailer::Base
  default from: "課程報名系統 <bennylin77@gmail.com.tw>"
  helper ApplicationHelper  
  
  def sendMessage(hash={}) 
    unless hash[:attachment].nil?
      hash[:attachment].each do |a|
        file=a
        attachments[file.original_filename] = File.open(file.path, 'rb'){|f| f.read}  
      end
    end    
    @user=hash[:user]
    @content=hash[:content]
    mail( to: @user.email, subject: hash[:subject])    
  end 
  
  def sendVerifyNotification(hash={}) 
    @user = hash[:user]
    @progress=hash[:progress]
    subject = "課程報名系統 #{@progress.item.group.title} 報名審核通知"    
    mail( to: @user.email, subject: subject)    
  end   
  
	def verified_result_send(progress)
    @data = progress
		subject = "課程報名系統 #{@data.item.group.title}"
		subject += (@data.stage==2) ? "已被取消報名" : "已報名成功"
		mail( to: @data.user.email, subject: subject)
	end	 
end
