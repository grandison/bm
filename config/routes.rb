VkMails::Application.routes.draw do
  resources :orders, only: [:new, :create, :show] do
    get :info
    get :generate
  end
  root to: "orders#new"
end