Rails.application.routes.draw do
  root to: 'homes#ask'
  get 'homes/ask', to: 'homes#ask'
  get 'homes/answer', to: 'homes#answer'
  post 'homes/answer', to: 'homes#answer'
  post 'homes/update', to: 'homes#update'
end
