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
    Rails.logger.debug "!!!!!!!!!!!"
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
  
  def uploadFile
    target = prarms[:type]=="head" ? :head_pic : :qualification_proof
    current_user.head_pic = params[:user][target]
    current_user.save!
    render :text=> {
      initialPreview: [
        "<img src='#{current_user[target].url}' class='file-preview-image' alt='Desert' title='Desert'>",
      ]}.to_json, :layout=>false
  end
  
  private  
  def set_user
    @user = User.find(params[:id])
  end
      
  def user_params
    params.require(:user).permit(:name, :phone_no, :postal, :county, :district, :address, :head_pic, :qualification_proof)
  end  
end