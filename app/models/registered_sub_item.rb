class RegisteredSubItem
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :progress
  belongs_to :sub_item
  
  #has_one :vaccount,  :dependent=> :destroy
    
  field :payment, type: Float, default: 0.0
 
end
