Rails.application.routes.draw do
  root to: 'homes#ask'
  get 'homes/ask' => 'homes#ask'
  get 'homes/answer', to: 'homes#answer'
  post 'homes/answer' => 'homes#answer'
  post "homes/get_location", to: "homes#get_location"
end
