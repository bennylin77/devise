# encoding: utf-8
class System < ActionMailer::Base
  default from: "國立交通大學推廣教育中心 <cce@nctu.edu.tw>"
  helper ApplicationHelper  
  
  def sendMessage(hash={}) 
    unless hash[:attachment].nil?
      hash[:attachment].each do |a|
        file=a
        attachments[file.original_filename] = File.open(file.path, 'rb'){|f| f.read}  
      end
    end    
    @user=hash[:user]
    @subject=hash[:subject]    
    @content=hash[:content]
    mail( to: @user.email, subject: @subject)    
  end 
  
	def verified_result_send(progress)
    @data = progress
		subject = "國立交通大學推廣教育中心 #{@data.item.group.title} 第#{@data.item.term}期"
		subject += (@data.stage==2) ? "已被取消報名" : "已報名成功"
		mail( :to=> @data.user.email, :subject=> subject)
	end	 
end
