class Progress
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  embedded_in :item, inverse_of: :progresses

  field :stage, type: Integer
  
end
