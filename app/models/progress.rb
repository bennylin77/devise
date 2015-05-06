class Progress
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :item
  belongs_to :user
	
	has_one  :vaccount, dependent: :destroy
  has_many :registered_sub_items, dependent: :destroy   

  accepts_nested_attributes_for :registered_sub_items


  field :stage, type: Integer
  field :waiting, type: Boolean, default: false
  field :waiting_no, type: Integer, default: 0    
  field :verified, type: Boolean, default: false 
  field :finished, type: Boolean, default: false
  field :payment, type: Float, default: 0.0
  field :reason, type: String, default: ''	
  
  field :score, type: Integer, default: 0.0
  field :attendance, type: Integer, default: 0.0
  field :certificate, type: Boolean, default: false  
  field :certificate_no, type: String
	
	field :feedback_done, type: Boolean, default: false
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

	def create_vaccount 
		vacc = Vaccount.new
		vacc.create_account(self.id)
		vacc.progress = self
		vacc.save!
	end
end
