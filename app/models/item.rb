class Item
  include Mongoid::Document
  include Mongoid::Timestamps   

#  embeds_many :evaluations
#  embeds_many :comments
  embeds_many :progress    
  belongs_to :user  
  
  field :title, type: String
  field :description, type: String
  field :start_at, type: DateTime  
  field :end_at, type: DateTime   
  field :no_of_user, type: Integer
  field :price, type: Float
  field :module, type: Integer
  field :verification_code, type: String 
  
  #CCE
  field :payment_strat_at, type: DateTime   
  field :payment_end_at, type: DateTime    
  
  validates :title, presence: {message: "名稱 不能是空白"}
  validates :description, presence: {message: "簡介 不能是空白"}
  validates :start_at, presence: {message: "報名開始時間 不能是空白"}  
  validates :end_at, presence: {message: "報名結束時間 不能是空白"}  
  validates :no_of_user, presence: {message: "報名人數 不能是空白"}
  validates :price, presence: {message: "金額 不能是空白"}    
  validates :payment_strat_at, presence: {message: "繳費開始時間 不能是空白"}
  validates :payment_end_at, presence: {message: "繳費結束時間 不能是空白"}    
    
end
