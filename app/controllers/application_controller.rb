class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
  
  
  def userBirthdayValidate(i)
    if i.blank?
      @user.errors.add :birthday, "請填寫  出生年月日"
    end  
  end  
  def userGenderValidate(i)
    if i.blank?
      @user.errors.add :gender, "請填寫  性別"
    end      
  end 
  def userPhoneNoValidate(i)
    if i.blank?
      @user.errors.add :phone_no, "請填寫  聯絡電話"
    end      
  end 
  def userPostalValidate(i)
    if i.blank?
      @user.errors.add :postal, "請填寫  郵遞區號"
    end      
  end       
  def userCountyValidate(i)
    if i.blank?
      @user.errors.add :county, "請填寫  縣市"
    end      
  end 
  def userDistrictValidate(i)
    if i.blank?
      @user.errors.add :district, "請填寫  鄉鎮市區"
    end      
  end 
  def userAddressValidate(i)
     if i.blank?
      @user.errors.add :address, "請填寫  地址"
    end     
  end     
  def userIDNoTWValidate(i)
     if i.blank?
      @user.errors.add :id_no_TW, "請填寫  身分證字號"
    end     
  end  
      
end
