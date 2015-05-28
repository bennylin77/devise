class Comment
  include Mongoid::Document
  include Mongoid::Timestamps   
  
  
  field :content, type: String
  field :up, type: Integer
  field :down, type: Integer 
  
  
end
