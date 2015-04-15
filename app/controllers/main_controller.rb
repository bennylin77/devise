class MainController < ApplicationController
  def index
  end
	
	def check_account
  	if request.post?
  		vacc = params[:vacc]
  		vc = Vaccount.new
  		vc.check_account(vacc)
  		vc.vacc = vacc
  		vc.update_status
  		@row = "<tr><td>#{vacc}</td>"
  		@row += "<td>#{vc.status["res"]["desc"]}</td>"
  		@row += "<td>#{vc.status["Amount"]}</td>"
  		@row += "<td>#{vc.status["PayChnl"]}</td></tr>"
  	end
  end
	
	def vaccounts
		@vaccounts = Vaccount.all
	
	end
	
end
