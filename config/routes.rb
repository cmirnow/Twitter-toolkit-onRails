Rails.application.routes.draw do
  resources :tweets
  devise_for :users
  resources :users do
  	member do
  		get :confirm_email
  	end
  end
  root to: 'tweets#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
