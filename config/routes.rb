Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :guests
  resources :restaurants
  resources :reservations
  resources :restaurant_shifts
  resources :restaurant_tables
end
