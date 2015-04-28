Rails.application.routes.draw do


  get  'nctu_cce/first'
  get  'nctu_cce/second'  
  post 'nctu_cce/second'   
  get  'nctu_cce/third'
  get  'nctu_cce/forth'  
  get  'nctu_cce/cancel'
  post 'nctu_cce/feedback'   
  get  'nctu_cce/new'
  post 'nctu_cce/create'
  get  'nctu_cce/destroy'
  get  'nctu_cce/indexManagement'  
  get  'nctu_cce/showProgress'  
  get  'nctu_cce/editItem'  
  post 'nctu_cce/updateItem'     
  get  'nctu_cce/editGroup'  
  post 'nctu_cce/updateGroup'      
  get  'nctu_cce/editScore'  
  post 'nctu_cce/updateScore'   
  get  'nctu_cce/sendMessage'
  post 'nctu_cce/sendMessage'
  post 'nctu_cce/verified'
  get  'nctu_cce/destroyProgress'

  get  'nctu_cce_credit/first' 
  get  'nctu_cce_credit/second'    
  post 'nctu_cce_credit/second' 
  get  'nctu_cce_credit/third'
  get  'nctu_cce_credit/forth'   
  get  'nctu_cce_credit/cancel'    
  get  'nctu_cce_credit/new' 
  get  'nctu_cce_credit/newCourses'  
  post 'nctu_cce_credit/newCourses'
  post 'nctu_cce_credit/create' 
  get  'nctu_cce_credit/destroy'  
  get  'nctu_cce_credit/indexManagement'  
  get  'nctu_cce_credit/showProgress'  
  get  'nctu_cce_credit/editItem'  
  post 'nctu_cce_credit/updateItem'    
  get  'nctu_cce_credit/editGroup'   
  post 'nctu_cce_credit/updateGroup'  
  get  'nctu_cce_credit/editCourses'
  post 'nctu_cce_credit/updateCourses'    
  get  'nctu_cce_credit/sendMessage'
  post 'nctu_cce_credit/sendMessage'  
  post 'nctu_cce_credit/updateCourses'  
  post 'nctu_cce_credit/verified' 	
  get  'nctu_cce_credit/destroyProgress'
        
  get  'main/index'
  
 
  get  'items/createCompletion' 
  get  'items/showManagement'
  get  'items/indexManagement'
  get  'items/progress'
  get  'items/progressStatus'  
  
  get  'system_modules/addAdmin'
  post 'system_modules/addAdmin'
  
  get  'system_modules/userIndex'
  get  'system_modules/userEdit'    
  get  'system_modules/userInfo'    
  post 'system_modules/userRole'    
  post 'system_modules/userAdd'  
  get  'system_modules/userDestroy'    
  
  get  'system_modules/check_account'
  post 'system_modules/check_account'
  get  'system_modules/vaccounts'
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :items  
  resources :users
  resources :system_modules  
  root to: "items#index"

end
