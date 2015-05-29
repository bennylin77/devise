class RegisteredCourse
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :progress
  belongs_to :course
  
    
  field :payment, type: Float, default: 0.0
  field :score, type: Integer, default: 0.0
  field :attendance, type: Integer, default: 0.0
  field :certificate, type: Boolean, default: false    
  field :certificate_no, type: String

  field :waiting, type: Boolean, default: false
  field :waiting_no, type: Integer, default: 0  

  field :nctu_cce_feedback_1_1, type: Integer
  field :nctu_cce_feedback_1_2, type: Integer
  field :nctu_cce_feedback_1_3, type: Integer
  field :nctu_cce_feedback_1_4, type: Integer
  field :nctu_cce_feedback_1_5, type: Integer
  field :nctu_cce_feedback_2_1, type: Integer
  field :nctu_cce_feedback_2_2, type: Integer    
  field :nctu_cce_feedback_2_3, type: Integer    
  field :nctu_cce_feedback_2_4, type: Integer    
  field :nctu_cce_feedback_2_5, type: Integer    
  field :nctu_cce_feedback_2_6, type: Integer    
  field :nctu_cce_feedback_2_7, type: Integer    
  field :nctu_cce_feedback_2_8, type: Integer   
  field :nctu_cce_feedback_2_9, type: Integer    
  field :nctu_cce_feedback_2_10, type: Integer    
  field :nctu_cce_feedback_2_11, type: Integer                         
  field :nctu_cce_feedback_3_1, type: String
  field :nctu_cce_feedback_4_1, type: Integer 
  field :nctu_cce_feedback_4_2, type: Integer 
  field :nctu_cce_feedback_4_3, type: Integer 
  field :nctu_cce_feedback_4_4, type: Integer 
  field :nctu_cce_feedback_4_5, type: Integer      
end
