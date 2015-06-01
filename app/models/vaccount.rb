class Vaccount 
	include Mongoid::Document
  include Mongoid::Timestamps   
	
	belongs_to :progress
	
	field :vacc, type: String #虛擬帳號
  field :status, type: Hash #更新時回傳的資訊
  field :active, type: Boolean, default: true  # 帳號是否啟動，用來決定是否要被sched_update_status

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
	
	# 
	def update_status		 
		http = Curl.post(ESURL, {"OrgId"=> COMPANY_ORGID, "VirtualAccount"=>self.vacc})
		xml_doc = Nokogiri::XML(http.body_str)
		return -1 if xml_doc == -1 #parse error, case by service maintaining 
		self.status = {
			"res"=>{
						"code"=>xml_doc.xpath('//ResCode')[0].try(:content),
						"desc"=>xml_doc.xpath('//ResDesc')[0].try(:content)
					},
			"PjName"=>xml_doc.xpath('//PjName')[0].try(:content),
			"Amount"=>xml_doc.xpath('//Amount')[0].try(:content), 
			"PayChnl"=>xml_doc.xpath('//PayChnl')[0].try(:content), 
			"PayState" => xml_doc.xpath('//PayState')[0].try(:content)
		}
		self.save!
		return 0
	end
	
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
	
end