Rails.application.routes.draw do
  root to: 'warehouses#index'
  resources :warehouses, only: [:show]
end
