class Group
  include Mongoid::Document
  include Mongoid::Timestamps     
  

  has_many :periods, dependent: :destroy
  belongs_to :system_module
  accepts_nested_attributes_for :periods 
  
  field :title, type: String
  field :description, type: String
    
end
