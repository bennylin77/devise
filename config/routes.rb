Rails.application.routes.draw do

  get  'nctu_cce/first'
  get  'nctu_cce/second'  
  get  'nctu_cce/third'
  get  'nctu_cce/editItem'  
  get  'nctu_cce/editGroup'  
  get  'nctu_cce/new'
  post 'nctu_cce/verified'
  get  'nctu_cce/indexManagement'
  get  'nctu_cce/showProgress'
  get  'nctu_cce/cancel'
  get  'nctu_cce/sendMessage'
  post 'nctu_cce/sendMessage'
  post 'nctu_cce/create'
  post 'nctu_cce/updateItem'   
  post 'nctu_cce/updateGroup'        
  post 'nctu_cce/second' 
  get  'nctu_cce/check_account' 
  post 'nctu_cce/check_account' 
 
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
      
  get  'main/index'
 
  get  'items/createCompletion' 
  get  'items/showManagement'
  get  'items/indexManagement'
  get  'items/progress'
  get  'items/progress_status'  
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  resources :items  
  resources :users
  root to: "items#index"

end
