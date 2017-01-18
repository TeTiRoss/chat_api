Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: :create
  resources :users
  resources :chats do
    put 'read', on: :member
    resources :messages, only: [:index, :create] do
      get 'unread', on: :collection
    end
  end
end
