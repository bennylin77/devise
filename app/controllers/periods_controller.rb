class PeriodsController < ApplicationController

  before_filter :authenticate_user!, only: [:indexManagement, :new, :create, :progress]   
  before_action :set_period, only: [:show, :edit, :update, :destroy, :createCompletion]
  before_action :set_progress, only: [:progressStatus]
  
	def nctuvaccount
		@zzs=Nctuvaccount.all.order("VAccount_TranDate DESC")
		#@zzs=Nctuvaccount.where(:VAccount_TranAccount=>"95306672277054")
	end
	
  def index
    @periods = Period.all.order('id desc').paginate(per_page: 30, page: params[:page])
  end
  
  def indexManagement
    @periods = current_user.periods.order('id desc')
  end

  def show
  end

  def new
  end

  def create
    # check identified code and redirect to right module
    case params[:module]
    when GLOBAL_VAR['BASIC'].to_s
      redirect_to controller: :basic, action: :new, module: params[:module]      
    when GLOBAL_VAR['NCTU_CCE'].to_s
      redirect_to controller: :nctu_cce, action: :new, module: params[:module]
    when GLOBAL_VAR['NCTU_CCE_credit'].to_s
      redirect_to controller: :nctu_cce_credit, action: :new, module: params[:module]
    when GLOBAL_VAR['NCTU_CCE_camp'].to_s
      redirect_to controller: :nctu_cce_camp, action: :new, module: params[:module]
    else
      flash[:error]='請選擇模組'
      redirect_to new_period_path
    end
  end
  
  def createCompletion
    flash.now[:success]='成功建立 '+@period.group.title
  end  
  
  def progress
    @progresses = current_user.progresses.order('stage aes')
  end   

  def export_vaccounts
    @period = Period.find(params[:id])   
  	if @period.user != current_user 
  	  redirect_to :root
  	end
  	
  	@group = @period.group
  	@progresses = @period.progresses.order_by(:user=> :desc)
    time_str = Time.now.strftime("%Y%m%d%H%M")
    #@sys_module.groups.map{|g| g.periods.map{|i| i.progresses.map{|p| p.vaccount}}}.flatten.compact
  	respond_to do |format|
			 format.xls{
			 	response.headers['Content-Type'] = "application/vnd.ms-excel"
			 	response.headers['Content-Disposition'] = " attachment; filename=\"#{time_str}帳單表.xls\" "	
			 }
		end	 
  
  end

  private
  
    def set_period
      @period = Period.find(params[:id])
    end
    
    def set_progress
      @progress = Period.find(params[:id])      
    end

    def period_params
      params.require(:period).permit(:module)
    end
end
