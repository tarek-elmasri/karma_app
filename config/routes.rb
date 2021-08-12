Rails.application.routes.draw do
  # get 'invoices/new' , to: "invoices#new"
  # post 'invoices', to: 'invoices#create'

  # get 'clients' , to: "clients#index"
  # post 'clients', to: 'clients#create'
  # get 'clients/new' , to: 'clients#new'
  # get 'clients/show'

  root to: 'sessions#log_in'
  post 'sign_in', to: 'sessions#sign_in'
  delete 'signout', to: 'sessions#destroy'
  resources :clients
  resources :invoices
  resources :charged_persons
  resources :payments
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
