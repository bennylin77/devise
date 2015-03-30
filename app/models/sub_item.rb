class SubItem
  include Mongoid::Document
  include Mongoid::Timestamps   
  
  belongs_to :item
  
  field :title, type: String
  field :price, type: Float  
  field :no_of_user, type: Integer  
  
end