VkMails::Application.routes.draw do
  resources :orders, only: [:new, :create, :show]
  root to: "orders#new"
end