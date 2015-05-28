class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all
  end

  def show
    @user = current_user
  end

  # GET /users/:id/edit
  def edit
    @user = current_user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        flash.now[:notice] ='成功更改個人資料'
        format.html { render action: 'edit' }
      else
        format.html { render action: 'edit' }
      end
    end
  end  
  private  
  def set_user
    @user = User.find(params[:id])
  end
      
  def user_params
    params.require(:user).permit(:name, :phone_no, :postal, :county, :district, :address, :head_pic, :qualification_proof)
  end  
end