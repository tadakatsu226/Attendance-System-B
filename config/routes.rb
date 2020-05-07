Rails.application.routes.draw do
  
  root 'static_pages#top'
  get '/signup' , to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'going_to_work'
    end 
    collection { post :import }
    
    resources :attendances do
      member do
        get 'edit_overtime_request'
        patch 'update_overtime_request'
        get 'edit_overtime_request_superior1'
        patch 'update_overtime_request_superior1' 
      end
    end  
  end
  
  resources :offices
  
end