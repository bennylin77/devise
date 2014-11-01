class User
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  has_many :items  
  has_many :progresses
  
  #validates_presence_of :uid, :provider
  #validates_uniqueness_of :uid, :scope => :provider    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  ## Database authenticatable
  field :email,              type: String, default: ""
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
  field :provider, type: String
  field :uid, type: String
  
  field :birthday, type: DateTime
  field :gender, type: Boolean  
  field :phone_no, type: String    
  
  field :postal, type: String
  field :county, type: String
  field :district, type: String
  field :address, type: String

  field :id_no_TW, type: String
  
  
  
  
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
