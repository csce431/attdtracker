Rails.application.routes.draw do
  resources :teacher
  resources :courses do
    resources :students
    resources :role
    resources :days do
      resources :cards
    end
  end
  resources :students do
    resources :courses
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

    # Routes for Google authentication
    get "/login", to: redirect("/auth/google_oauth2")
    get '/logout', to: 'session#destroy'
    get "auth/google_oauth2/callback", to: "sessions#googleAuth"
    get "auth/failure", to: redirect("/")
    resource :session, only: [:googleAuth, :destroy]

  # You can have the root of your site routed with "root"
  
  root 'welcome#index'
  #root 'home#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
