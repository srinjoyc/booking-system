Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :guests
  resources :restaurants
  resources :reservations
  resources :restaurant_shifts
  resources :restaurant_tables

  post '/mobile-create-reservation', to: 'reservations#mobile_create'
  get '/', to: 'static#index'
end
