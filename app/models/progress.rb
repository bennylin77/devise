class Progress
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :item
  belongs_to :user

  field :stage, type: Integer
  
end
