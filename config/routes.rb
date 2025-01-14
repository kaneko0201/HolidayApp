Rails.application.routes.draw do
  root to: 'homes#index'
  post '/api/homes_suggestions', to: 'homes#suggest'
  resources :homes, only: [:show]
end
