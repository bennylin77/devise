class Vaccount 
	include Mongoid::Document
  include Mongoid::Timestamps   
	
	belongs_to :progress
	
	field :vacc, type: String
  field :status, type: Hash
  field :active, type: Boolean, default: true 

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
		xml_doc = parse_xml(http.body_str)
		return -1 if xml_doc == -1 #parse error, case by service maintaining 
		#p xml_doc
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
	
private	
	def parse_xml(result)
		xml = ""
		result.split( /\r?\n/ ).each do |line|
			break if line.include? "<script>"
			next if line.include? "<script"  or line.include? "?xml" 
		 
			line = line.tr("\t",'').tr("<br>",'')
			if line.length > 0
				if line.include? "span"
					xml += line[19..-8]+"\n"
				else   
					xml += line+"\n"
				end
			end
		end
		begin
			xml = HTMLEntities.new.decode(xml.force_encoding("utf-8")) # encode to utf8 and decode from html
		rescue
			return -1
		end
		#print xml+"\n ============ \n" 
		return Nokogiri::XML(xml)
	end
	
	
end