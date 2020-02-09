Rails.application.routes.draw do
  #resources :widgets
  resources :home
  resources :teacher
  resources :courses do
    resources :students
  end
  resources :students do
    resources :courses
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  
  root 'welcome#index'
  #root 'home#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
