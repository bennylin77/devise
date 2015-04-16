class ModuleUserList
  include Mongoid::Document
  
  belongs_to :user
  belongs_to :system_module  
  
  field :role, type: Integer  
    
  def module_id; "#{self.system_module.serial_code}";end    
  
  def module_title; "#{self.system_module.title}";end
  
end
