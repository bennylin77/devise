class Course
  include Mongoid::Document
  include Mongoid::Timestamps   
  
  belongs_to :period
  has_many   :registered_courses     
  
  field :title, type: String
  field :price, type: Float  
  field :no_of_users, type: Integer  

  field :start_at, type: DateTime  
  field :end_at, type: DateTime  
  field :location, type: String
   
end