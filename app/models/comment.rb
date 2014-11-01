class Comment
  include Mongoid::Document
  include Mongoid::Timestamps   
  
  recursively_embeds_many  
  
  belongs_to :user 
  belongs_to :item
  embedded_in :user
  embedded_in :group
  
  field :content, type: String
  field :up, type: Integer
  field :down, type: Integer 
  
  
  
end
