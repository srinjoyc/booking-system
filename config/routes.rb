Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :guests
  resources :restaurants
  resources :reservations
  resources :restaurant_shifts
  resources :restaurant_tables

  get '*other', to: 'static#index'
end
