Rails.application.routes.draw do
  resources :teacher do
    resources :courses do
      resources :students
      resources :role
      resources :days do
        resources :cards
      end
    end
  end
  
  resources :courses do
    resources :students
    resources :role
    resources :cards
    resources :users
    resources :days do
      resources :cards
    end
  end
  
  resources :students# do
   # resources :courses
  #end

  post '/courses/:id/import', to: 'courses#import'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  
  root 'welcome#index'
  #root 'home#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
