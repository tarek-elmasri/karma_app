Rails.application.routes.draw do

  root to: 'sessions#log_in'
  post 'sign_in', to: 'sessions#sign_in'
  delete 'signout', to: 'sessions#destroy'
  resources :clients
  get 'client_search' , to: 'clients#search', as: 'client_search'
  get 'search/new', to: "searches#new", as: 'new_search'
  post 'search/create', to: "searches#create", as: 'adv_search'
  get 'search/clients', to: "searches#clients_search", as: 'adv_client_search'
  resources :invoices
  resources :charged_persons
  resources :payments
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
