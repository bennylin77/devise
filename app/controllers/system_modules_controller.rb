class SystemModulesController < ApplicationController
  before_action :set_system_module, only: [:show, :edit, :update, :destroy, :addAdmin, :userEdit, :userAdd]

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
      mu.user = User.find(params[:user_id])     
      mu.system_module = @system_module
      mu.save!
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
        flash.now[:success] = '成功加入模組'      
      else
        flash.now[:error] = '查無此會員'  
      end  
    else
      flash.now[:error] = '此會員已加入模組'
    end   
    
    render :userEdit 
  end

  def userInfo
    @users_json=Array.new
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
    mu = ModuleUserList.find(params[:id])
    mu.role = params[:val]
    mu.save!
    render json: {success: true, message: '成功更改模組權限'}       
  end
  private
    def set_system_module
      @system_module = SystemModule.find(params[:id])
    end

    def system_module_params
      params.require(:system_module).permit(:title, :serial_code)
    end
end
