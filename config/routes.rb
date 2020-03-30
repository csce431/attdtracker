Rails.application.routes.draw do
<<<<<<< HEAD
=======
  resources :teacher do
    resources :courses do
      resources :students
      resources :role
      resources :days do
        resources :cards
      end
    end
  end
  
>>>>>>> crud
  resources :courses do
    resources :students
    resources :role
    resources :cards
    resources :users
    resources :days do
      resources :cards
    end
  end
<<<<<<< HEAD
  resources :students do
    resources :courses
  end
  resources :users do
    resources :courses
  end
  
  get '/courses/:course_id/days/:day_id/cards:new2(.:format)', to: 'cards#newer'
=======

  
  resources :students# do
   # resources :courses
  #end

  post '/courses/:id/import', to: 'courses#import'
>>>>>>> crud

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

    # Routes for Google authentication
    get "/login", to: redirect("/auth/google_oauth2")
    get '/logout', to: 'session#destroy'
    get "auth/google_oauth2/callback", to: "sessions#googleAuth"
    get "auth/failure", to: redirect("/")
    resource :session, only: [:googleAuth, :destroy]

  # You can have the root of your site routed with "root"
  
  root 'sessions#index'
  #root 'home#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
