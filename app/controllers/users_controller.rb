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
    elsif params[:type]=="qualification_proof" 
      current_user.qualification_proof = params[:user][:qualification_proof]
      data = current_user.qualification_proof
    elsif params[:type]=="id_no_TW_pic"       
      current_user.id_no_TW_pic = params[:user][:id_no_TW_pic]
      data = current_user.id_no_TW_pic
    elsif params[:type]=="transcripts_copy"       
      current_user.transcripts_copy = params[:user][:transcripts_copy]
      data = current_user.transcripts_copy 
    elsif params[:type]=="work_proof"             
      current_user.work_proof = params[:user][:work_proof]
      data = current_user.work_proof
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
    params.require(:user).permit(:email, :email_backup, :birthday, :gender, :id_no_TW, :ARC_no_TW, :mobile_phone_no, :phone_no, :address, 
                                 :postal, :county, :district, :name_en, :hightest_education_school, :hightest_education_department,
                                 :work_name, :work_title, :work_phone_no, :work_fax_no, :work_county, :work_district, :work_postal, :work_address,
                                 :work_contact_name, :work_contact_phone_no, :work_contact_email, :head_pic, :qualification_proof, :nationality)
  end  
end