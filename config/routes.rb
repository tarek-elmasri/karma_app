Rails.application.routes.draw do

  root to: 'sessions#log_in'
  get "main", to: "main#index", as: "main"

  post 'sign_in', to: 'sessions#sign_in'
  delete 'signout', to: 'sessions#destroy'

  get 'clients/search', to: "clients#search", as: 'clients_search'
  resources :clients

  get 'search/new', to: "searches#new", as: 'new_search'
  post 'search/create', to: "searches#create", as: 'adv_search'
  
  get 'search/invoices', to: "searches#invoices_search", as: 'adv_invoice_search'
  resources :invoices  , except: [:destroy]
  resources :charged_persons , only: [:create,:destroy]
  resources :payments
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
