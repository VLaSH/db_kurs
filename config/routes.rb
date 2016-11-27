Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :providers
  resources :products
  resources :categories
  resources :availabilities
  resources :deliveries
end
