class Group
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  embeds_many :comments
  has_many :items
  
  accepts_nested_attributes_for :items 
  
  field :title, type: String
  field :description, type: String
  field :module, type: Integer  

  validates :title, presence: {message: "名稱 不能是空白"}
  validates :description, presence: {message: "簡介 不能是空白"}  
        
end
