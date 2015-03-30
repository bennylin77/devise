class Item
  include Mongoid::Document
  include Mongoid::Timestamps   

#  embeds_many :evaluations
#  embeds_many :comments
  has_many :progresses  
  has_many :sub_items   
  belongs_to :user  
  belongs_to :group
#accepts_nested_attributes_for :sub_items 

  
  field :start_at, type: DateTime  
  field :end_at, type: DateTime   
  field :no_of_user, type: Integer
  field :no_of_waiting_user, type: Integer, default: 0  
  field :waiting_start, type: Boolean, default: false    
  field :price, type: Float
  field :school_year, type: Integer
  field :semester, type: Integer
  field :term, type: Integer 
  field :waiting_available, type: Boolean, default: false
   
  #CCE
  field :verification_code, type: String   
  field :payment_strat_at, type: DateTime   
  field :payment_end_at, type: DateTime    
  
  #validates :start_at, presence: {message: "報名開始時間 不能是空白"}  
  #validates :end_at, presence: {message: "報名結束時間 不能是空白"}  
  #validates :no_of_user, presence: {message: "報名人數 不能是空白"}
  #validates :price, presence: {message: "金額 不能是空白"}    
  #validates :payment_strat_at, presence: {message: "繳費開始時間 不能是空白"}
  #validates :payment_end_at, presence: {message: "繳費結束時間 不能是空白"}    
    
end
