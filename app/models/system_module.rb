class SystemModule
  include Mongoid::Document
  
  has_many :module_user_lists, dependent: :destroy    
  has_many :groups
  
  field :title, type: String
  field :serial_code, type: Integer
  

end
