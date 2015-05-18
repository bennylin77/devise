class Period
  include Mongoid::Document
  include Mongoid::Timestamps   

#  embeds_many :evaluations
#  embeds_many :comments
  has_many :progresses, dependent: :destroy  
  has_many :courses, dependent: :destroy   
  belongs_to :user  
  belongs_to :group
  accepts_nested_attributes_for :courses 

=begin  
  field :no_of_users, type: Integer
  field :no_of_waiting_users, type: Integer, default: 0  
  field :waiting_start, type: Boolean, default: false  
  field :waiting_available, type: Boolean, default: false     # accept waiting?    
=end  
  field :school_year, type: Integer
  field :semester, type: Integer
  field :term, type: Integer 
   
  field :start_at, type: DateTime  
  field :end_at, type: DateTime 
  field :payment_start_at, type: DateTime   
  field :payment_end_at, type: DateTime    
   
end
