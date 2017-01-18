Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: :create
  resources :users
  resources :chats do
    resources :messages, only: [:index, :create]
  end
end
