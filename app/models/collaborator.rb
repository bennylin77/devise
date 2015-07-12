class Collaborator
  include Mongoid::Document
  include Mongoid::Timestamps     
  

  belongs_to :period
  belongs_to :user
  

    
end