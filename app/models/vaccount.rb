class Vaccount 
	include Mongoid::Document
  include Mongoid::Timestamps   
	
	belongs_to :progress
	
	field :vacc, type: String #虛擬帳號
  field :status, type: Hash #更新時回傳的資訊 （最後一筆）
  field :last_transfer_time, type: String, default: "N/A"
  field :active, type: Boolean, default: true  # 帳號是否啟動，用來決定是否要被sched_update_status
  field :money, type: Integer, default: 0
  
  field :ack_status, type: Boolean, default: false #認領狀況  
  field :paid_by, type: String #繳款人
  field :purpose, type: String #收據事由
  field :receive_no, type: String #收據號碼
  field :is_closed, type: Boolean, default: false #銷帳狀況   
  
  
	# Create new virtual account. 
	# Note that it will cover the older
	def create_account(id) 
		# TO-DO: use id to generate code
		uniacc = COMPANY_CODE.split('').map(&:to_i)
		rand = Random.new(Time.now.sec)
		(1..8).each do |i|
			uniacc.push(rand(0..9))
		end	
		uniacc.push(gen_checksum(uniacc))
		self.vacc =  uniacc.map(&:to_s).join('')
	end
	#def updateIsclosed
		#@vacc=Nctuvaccount.where(:VAccount_TranAccount=>self.vacc)
	#end
	def updateIsclosedAndReceiveNo
		vaccs=Nctuvaccount.where(:VAccount_TranAccount=>self.vacc).order("VAccount_TranDateTime DESC")
		return if vaccs.empty?
		self.is_closed=vaccs[0].VAccount_IsClosed
		self.receive_no=vaccs[0].VAccount_ReceiveNum
		self.save
	end
	
	def syncMssqlPurpose
		Nctuvaccount.where(:VAccount_TranAccount=>self.vacc).update_all(
			:VAccount_Purpose=>self.purpose
		)
	end
	
	def syncMssqlPaidByAndAck
		Nctuvaccount.where(:VAccount_TranAccount=>self.vacc).update_all(
			:VAccount_PaidBy=>self.paid_by,
			:VAccount_AckStatus=>self.ack_status ? "已認領" : "未認領"
		)
	end
	
	def update_status		 
		#照時間倒序排
		@vacc=Nctuvaccount.where(:VAccount_TranAccount=>self.vacc).order("VAccount_TranDateTime DESC")
		
		if @vacc.empty?
			self.status = {
				"res"=>{
					"code"=> "1000",
					"desc"=>"查無繳款紀錄"
				}
			}
		else
			amount=0
			@vacc.each do |vac|
				amount+=vac.VAccount_TranAmount.to_i
			end
			last_vacc=@vacc[0]
			self.status = {
				"res"=>{
					"code"=> "0000",
					"desc"=>"正常"
				},
				"PjName"=>"XXX清算專案",
				"Amount"=>amount,
				"PayChnl"=> last_vacc.VAccount_TranNote, 
				"PayState" => last_vacc.VAccount_AckStatus,
				"PayDate" => last_vacc.VAccount_TranDateTime
			}
			
			self.money=self.status["Amount"]
			self.last_transfer_time=self.status["PayDate"]
		end
		#self.last_transfer_time = date
		self.save!
		
		return 0
	end
	
=begin ##########old
	def update_status		 

		http = Curl.post(ESURL, {"OrgId"=> COMPANY_ORGID, "VirtualAccount"=>self.vacc})
	#	Rails.logger.debug http.body_str
		xml_doc = Nokogiri::XML(http.body_str)
		if xml_doc == -1 #parse error, case by service maintaining 
		  self.touch
		  return -1 
		end
		
		
		paychl = paychnl_desc(xml_doc.xpath('//PayChnl')[0].try(:content))
		paystate = patstate_desc(xml_doc.xpath('//PayState')[0].try(:content))
		amount = xml_doc.xpath('//Amount')[0].try(:content)
		date = xml_doc.xpath('//PayDate')[0].try(:content)

    if amount.present? and self.last_transfer_time != date # 檢查本次查詢結果是否為同一筆
      self.money += amount.to_i
    else
      self.money = amount.to_i  
    end
		
		
		self.status = {
			"res"=>{
						"code"=> xml_doc.xpath('//ResCode')[0].try(:content),
						"desc"=>xml_doc.xpath('//ResDesc')[0].try(:content)
					},
			"PjName"=>xml_doc.xpath('//PjName')[0].try(:content),
			"Amount"=>amount, 
			"PayChnl"=> paychl, 
			"PayState" => paystate,
			"PayDate" => date
		}
		self.last_transfer_time = date
		self.save!
		
		
		return 0
	end
=end	
	# check account for 95306
	def check_account(str)
		return false unless str.include? "95306"
		checksum = str[-1].to_i
		len = str.length
		chs = 0
		ary = str.split("").map(&:to_i)
		ary.pop
		chs = self.gen_checksum(ary)
		
		#print "checksum=#{chs%10}\n"
		return true if checksum==chs%10
		return false
	end
	
	def gen_checksum(ary) # input account without checksum
		chs = 0 
		ary.reverse.each_with_index do |i, idx|
			idx +=1
			case idx
				when 1..9
					chs += i*idx
				else
					chs += i*(idx-9)
			end
		end
		return chs%10
	end
	
private

  def paychnl_desc(data)
    return "N/A" if !data
	  case data.to_i
	    when 0
	      "自收"
	    when 1
	      "臨櫃"
	    when 2
	      "匯款"  
	    when 3
	      "ATM"  
	    when 4 
	      "WebATM 即時付" 
	    when 5  
	      "語音/網路"
	    when 6  
	      "全國繳費稅"
	    when 7  
	      "SmartPay"
	    when 11
	      "玉山信用卡平台"
	    when 12
	      "中信信用卡平台"
	    when 13
	      "iBon"
	    when 14
	      "OK-GO"
	    when 15
	      "Life-ET"
	    when 16
	      "FamiPort"
	    when 21
	      "統一超商"          
	    when 22
	      "OK 便利商店"
	    when 23
	      "萊爾富便利商店"    
	    when 24
	      "全家便利商店"
	    when 25
	      "郵局"   
	    when 26
	      "E 政府信用卡平台"
	    when 27
	      "E 政府語音平台"
	    when 28
	      "本行代扣"
	    when 29
	      "ACH 代扣"
	    when 30
	      "就貸繳款"        
	    else
	      data.to_s  
	  end
	end
	
	def patstate_desc(data)
	  return "N/A" if !data
	  case data.to_i
	    when 0
	      "未繳款"
	    when 1
	      "已繳款"
	    else
	      data
	  end
	end
	
end
