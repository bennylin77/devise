class RegisteredSubItem
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :progress
  belongs_to :sub_item
  
  has_one :vaccount,  :dependent=> :destroy

  field :waiting, type: Boolean, default: false
  field :waiting_no, type: Integer, default: 0     
  field :payment, type: Float, default: 0.0
 
end
