class Progress
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :item
  belongs_to :user

  field :stage, type: Integer
  field :verified, type: Boolean, default: false 
  field :finished, type: Boolean, default: false
end
