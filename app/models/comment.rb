class Comment
  include Mongoid::Document
  include Mongoid::Timestamps   
  
  recursively_embeds_many  
  belongs_to :user 
  
  field :content, type: String
  field :up, type: Integer
  field :down, type: Integer 
  
  
end
