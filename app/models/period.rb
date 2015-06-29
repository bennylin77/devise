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

  field :school_year, type: Integer
  field :semester, type: Integer
  field :term, type: Integer 
   
  field :start_at, type: Time 
  field :end_at, type: Time 
  field :payment_start_at, type: Time   
  field :payment_end_at, type: Time    
  field :precautions, type: String
  field :eligibility, type: String
  field :default_payment, type: Integer, default: 0 
   
end
