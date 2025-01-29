Rails.application.routes.draw do
  root to: 'homes#index'
  get 'homes/ask' => 'homes#ask'
  post 'homes/answer' => 'homes#answer'
end
