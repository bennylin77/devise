Rails.application.routes.draw do



  get  'nctu_cce/first'
  get  'nctu_cce/second'  
  get  'nctu_cce/third'
  get  'nctu_cce/editItem'  
  get  'nctu_cce/editGroup'  
  get  'nctu_cce/new'
  post 'nctu_cce/verified'
  get  'nctu_cce/destroyProgress'
  get  'nctu_cce/indexManagement'
  get  'nctu_cce/showProgress'
  get  'nctu_cce/cancel'
  get  'nctu_cce/sendMessage'
  post 'nctu_cce/sendMessage'
  post 'nctu_cce/create'
  post 'nctu_cce/updateItem'   
  post 'nctu_cce/updateGroup'        
  post 'nctu_cce/second' 
	get  'nctu_cce/forth'


  get  'nctu_cce_credit/cancel' 
  get  'nctu_cce_credit/first' 
  get  'nctu_cce_credit/second'    
  post 'nctu_cce_credit/second' 
  get  'nctu_cce_credit/third'
  get  'nctu_cce_credit/new' 
  get  'nctu_cce_credit/newCourses'  
  post 'nctu_cce_credit/newCourses'
  post 'nctu_cce_credit/create' 
  get  'nctu_cce_credit/indexManagement'  
  get  'nctu_cce_credit/editItem'  
  get  'nctu_cce_credit/editGroup'   
  get  'nctu_cce_credit/editCourses'
  get  'nctu_cce_credit/sendMessage'
  post 'nctu_cce_credit/sendMessage'  
  post 'nctu_cce_credit/updateItem'   
  post 'nctu_cce_credit/updateGroup'  
  post 'nctu_cce_credit/updateCourses'  
  get  'nctu_cce_credit/showProgress'
  post 'nctu_cce_credit/verified' 	
      
  get  'main/index'
	get  'main/check_account'
	post 'main/check_account'
  get  'main/vaccounts'
 
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
  get 'system_modules/userDestroy'    
  
  
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :items  
  resources :users
  resources :system_modules  
  root to: "items#index"

end
