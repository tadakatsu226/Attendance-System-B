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
      get 'check_show'
    end 
    
    collection { post :import } 
              

    resources :attendances do
      member do
        get 'edit_overtime_request'
        patch 'update_overtime_request'
        get 'edit_overtime_request_superior'
        patch 'update_overtime_request_superior' 
        get 'edit_overtime_request_superior4'
        patch 'update_overtime_request_superior4' 
        get 'change_of_attendance1'
        patch 'update_change_of_attendance1'
        get 'change_of_attendance2'
        patch 'update_change_of_attendance2'
        get 'designation_log'
        get 'one_month_request'
        get 'edit_one_month_request'
        patch 'update_one_month_request'
        get 'edit_one_month_application'
        get 'csv_output'
      end
    end 
    patch 'update_one_month_application' 
  end
  
  resources :offices do
  end
  
end