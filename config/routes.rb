# -*- encoding : utf-8 -*-
VkMails::Application.routes.draw do
  resources :orders, only: [:new, :create, :show] do
    get :info
    get :boom
    # get :generate_with_names
    # get :generate_full
  end
  root to: "orders#new"
end
