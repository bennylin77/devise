class User
  include Mongoid::Document
  include Mongoid::Timestamps  
  include Mongoid::Paperclip
  
  has_mongoid_attached_file :head_pic,
      :path => ":rails_root/public/user/:attachment/:id/:style/:filename",
      :url => "/user/:attachment/:id/:style/:filename",
      :styles => { :small => "200x200>", :medium => "500x500>" }
  validates_attachment_content_type :head_pic, :content_type => %w(image/jpeg image/jpg image/png), 
                                    :message=>"只接受 .jpeg .jpg .png 等圖檔"
  validates_attachment_size :head_pic , :less_than => 10.megabytes, :message=>"file size too big( <10mb ) "   
  
  has_mongoid_attached_file :qualification_proof,
      :path => ":rails_root/public/user/:attachment/:id/:style/:filename",
      :url => "/user/:attachment/:id/:style/:filename"
  validates_attachment_content_type :qualification_proof, :content_type => %w(image/jpeg image/jpg image/png application/pdf),
                                    :message=>"只接受 .jpeg .jpg .png 圖檔或pdf文件"
  validates_attachment_size :qualification_proof , :less_than => 10.megabytes, :message=>"file size too big( <10mb ) "    
  
  has_mongoid_attached_file :id_no_TW_pic,
      :path => ":rails_root/public/user/:attachment/:id/:style/:filename",
      :url => "/user/:attachment/:id/:style/:filename"
  validates_attachment_content_type :id_no_TW_pic, :content_type => %w(image/jpeg image/jpg image/png application/pdf),
                                    :message=>"只接受 .jpeg .jpg .png 圖檔或pdf文件"
  validates_attachment_size :id_no_TW_pic, :less_than => 10.megabytes, :message=>"file size too big( <10mb ) "   
  
  has_mongoid_attached_file :transcripts_copy,
      :path => ":rails_root/public/user/:attachment/:id/:style/:filename",
      :url => "/user/:attachment/:id/:style/:filename"
  validates_attachment_content_type :transcripts_copy, :content_type => %w(image/jpeg image/jpg image/png application/pdf),
                                    :message=>"只接受 .jpeg .jpg .png 圖檔或pdf文件"
  validates_attachment_size :transcripts_copy, :less_than => 10.megabytes, :message=>"file size too big( <10mb ) " 
  
  has_mongoid_attached_file :work_proof,
      :path => ":rails_root/public/user/:attachment/:id/:style/:filename",
      :url => "/user/:attachment/:id/:style/:filename"
  validates_attachment_content_type :work_proof, :content_type => %w(image/jpeg image/jpg image/png application/pdf),
                                    :message=>"只接受 .jpeg .jpg .png 圖檔或pdf文件"
  validates_attachment_size :work_proof, :less_than => 10.megabytes, :message=>"file size too big( <10mb ) " 
  
  has_many :collaborators    
  has_many :periods  
  has_many :progresses
  has_many :module_user_lists  
  accepts_nested_attributes_for :progresses   
  
  #validates_presence_of :uid, :provider
  #validates_uniqueness_of :uid, :scope => :provider    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :email_backup,       type: String, default: ""  
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: DateTime

  ## Rememberable
  field :remember_created_at, type: DateTime

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: DateTime
  field :last_sign_in_at,    type: DateTime
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :name, type: String 
  field :name_en, type: String 
    
  field :provider, type: String
  field :uid, type: String
  
  field :birthday, type: Time
  field :gender, type: Boolean  
  field :mobile_phone_no, type: String    
  field :phone_no, type: String    
  
  field :postal, type: String
  field :county, type: String
  field :district, type: String
  field :address, type: String

  field :nationality, type: String, default: 'TW'
  field :id_no_TW, type: String
  field :ARC_no_TW, type: String
    
  field :hightest_education_school, type: String
  field :hightest_education_department, type: String  
  field :hightest_education_grade, type: String  

  field :vegetarian, type: Boolean, default: false
  
  field :work_name, type: String
  field :work_title, type: String
  field :work_phone_no, type: String  
  field :work_fax_no, type: String    
  field :work_postal, type: String
  field :work_county, type: String
  field :work_district, type: String
  field :work_address, type: String   
  field :work_contact_name, type: String
  field :work_contact_phone_no, type: String
  field :work_contact_email, type: String
  
  
  validates :name, presence: {}  
  
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    user = User.where(provider: auth.provider, uid: auth.uid ).first
    
    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    #user = signed_in_resource ? signed_in_resource : user_existed
    
    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          provider:auth.provider,
          uid:auth.uid,          
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        #user.skip_confirmation! 
        user.save!
      end
    end   
    user
  end  
end
