class Progress
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :period
  belongs_to :user
	has_one  :vaccount, dependent: :destroy
  has_many :registered_courses, dependent: :destroy   
  accepts_nested_attributes_for :registered_courses

  field :source, type: Integer
  field :receipt_title, type: String  

  field :stage, type: Integer    
  field :verified, type: Boolean, default: false 
  field :finished, type: Boolean, default: false
  field :feedback_done, type: Boolean, default: false  
  field :payment, type: Integer, default: 0
  field :reason, type: String, default: ''	

	def create_vaccount 
		vacc = Vaccount.new
		vacc.create_account(self)
		vacc.progress = self
		vacc.save!
	end
end
