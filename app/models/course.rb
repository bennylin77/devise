class Course
  include Mongoid::Document
  include Mongoid::Timestamps   
  
  belongs_to :period
  has_many   :registered_courses     
  
  field :title, type: String
  field :price, type: Integer  
  field :no_of_users, type: Integer    

  field :start_at, type: Date  
  field :end_at, type: Date  
  field :location, type: String
  
  field :no_of_waiting_users, type: Integer, default: 0  
  field :waiting_start, type: Boolean, default: false  
  field :waiting_available, type: Boolean, default: false     # accept waiting?    
   
end