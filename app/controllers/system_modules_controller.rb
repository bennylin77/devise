class SystemModulesController < ApplicationController
  
  before_filter :authenticate_user!   
  before_action :set_system_module, only: [:show, :edit, :update, :destroy, :addAdmin, :userEdit, :userAdd, :userDestroy]
  before_action only: [:userAdd, :userDestroy, :userInfo, :userRole, :userDestroy] { |c| c.ModuleCheckUser(params[:id], GLOBAL_VAR['ROLE_ADMIN'])}   
  before_action only: [:index, :show, :new, :edit, :addAdmin, :create, :update, :destroy, :check_account, :vaccounts] { |c| c.ModuleCheckAdmin()}  

  respond_to :html

  def index
    @system_modules = SystemModule.all
    respond_with(@system_modules)
  end

  def show
    respond_with(@system_module)
  end

  def new
    @system_module = SystemModule.new
    respond_with(@system_module)
  end

  def edit
  end

  def addAdmin
    if request.post?
      mu = ModuleUserList.new(role: GLOBAL_VAR['ROLE_ADMIN'])
      unless User.where(email: params[:email]).first.blank?  
        mu.user = User.where(email: params[:email]).first           
        mu.system_module = @system_module
        mu.save!
      else
        flash[:error] = '無此會員信箱'  
      end    
      redirect_to @system_module
    end
  end

  def create
    @system_module = SystemModule.new(system_module_params)
    @system_module.save
    respond_with(@system_module)
  end

  def update
    @system_module.update(system_module_params)
    respond_with(@system_module)
  end

  def destroy
    @system_module.destroy
    respond_with(@system_module)
  end
#====== user ======#
  def userIndex
    @module_user_lists = current_user.module_user_lists
  end
  
  def userEdit
  end
  
  def userAdd
    
    unless @system_module.module_user_lists.where(:user_id.in => User.where(email: params[:email]).pluck(:id)).count > 0    
      unless User.where(email: params[:email]).count == 0
        mu = ModuleUserList.new(role: params[:role])
        mu.user = User.where(email: params[:email]).first   
        mu.system_module = @system_module
        mu.save!
        flash[:success] = '成功加入模組'      
      else
        flash[:error] = '查無此會員'  
      end  
    else
      flash[:error] = '此會員已加入模組'
    end   
    redirect_to controller: 'system_modules', action: 'userEdit', id: @system_module.id
  end

  def userInfo
    @users_json = Array.new
    @users = User.where(email: /.*#{params[:email]}.*/)
    @users.each do |c|
      @users_json << 
      {
        label: c.email+' '+c.name,
        value: c.email
      }
    end  
    render json: @users_json.to_json         
  end
  
  def userRole
    mu = ModuleUserList.find(params[:module_user_id])
    mu.role = params[:val]
    mu.save!
    render json: {success: true, message: '成功更改成員權限'}       
  end
  
  def userDestroy
    mu = ModuleUserList.find(params[:module_user_id])
    mu.destroy!    
    flash[:success] = '成功刪除成員'
    
    redirect_to controller: 'system_modules', action: 'userEdit', id: @system_module.id    
  end

## vaccount
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
	@sys_module = SystemModule.find(params[:id])
	@vaccounts = @sys_module.groups.map{|g| g.items.map{|i| i.progresses.map{|p| p.vaccount}}}.flatten.compact
  end
   
  def ModuleCheckAdmin
    if current_user.email != 'bennylin77@gmail.com'      
      flash["error"]="您沒有權限"
      redirect_to root_url          
    end      
  end  
  
  
  
  private
    def set_system_module
      @system_module = SystemModule.find(params[:id])
    end

    def system_module_params
      params.require(:system_module).permit(:title, :serial_code)
    end
end
