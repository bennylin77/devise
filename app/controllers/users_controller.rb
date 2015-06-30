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
        flash[:notice] ='成功更改個人資料'
        format.html { redirect_to edit_user_path }
      else
        format.html { render action: 'edit' }
      end
    end
    
  end  
  
  def uploadFile
    data = ""
    if params[:type]=="head"
      current_user.head_pic = params[:user][:head_pic]
      data = current_user.head_pic
    else
      current_user.qualification_proof = params[:user][:qualification_proof]
      data = current_user.qualification_proof
    end 
    current_user.save!
    
    render :text=> {
      initialPreview: [
        "<img src='#{data.url}' class='file-preview-image' alt='Desert' title='Desert'>",
      ]}.to_json, :layout=>false
  end
  
  private  
  def set_user
    @user = User.find(params[:id])
  end
      
  def user_params
    params.require(:user).permit(:email, :name, :phone_no, :postal, :county, :district, :address, :head_pic, :qualification_proof)
  end  
end