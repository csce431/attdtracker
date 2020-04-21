Rails.application.routes.draw do

  resources :courses do
    resources :students
    resources :days do
      resources :cards
      get 'card/promptemail', to: 'cards#promptemail'
    end
  end
  
  resources :teachers do
    resources :courses
  end

  resources :students do
    get 'studentEdit', to: 'students#studentEdit'
  end
  resources :admins

  get '/admins/new1', to: 'admins#show'

  #resources :courses do
  #  resources :students
  #  resources :role
  #  resources :cards
  #  resources :users
  #  resources :days do
  #    resources :cards
  #    get 'card/promptemail', to: 'cards#promptemail'
  #  end
  #end

  post '/courses/:id/import', to: 'courses#import'

  # get "/assets/hex.jpg", to: "/app/assets/images/hex.jpg"
  # get "/assets/poly.jpg", to: "/app/assets/images/poly.jpg"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

    # Routes for Google authentication
    get "/login", to: redirect("/auth/google_oauth2")
    get '/logout', to: 'sessions#destroy'
    get "auth/google_oauth2/callback", to: "sessions#googleAuth"
    get "auth/failure", to: redirect("/")
    resource :session, only: [:googleAuth, :destroy]

  # You can have the root of your site routed with "root"
  
  root 'sessions#index'
  #root 'home#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
