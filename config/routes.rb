# -*- encoding : utf-8 -*-
VkMails::Application.routes.draw do
  resources :orders, only: [:new, :create, :show] do
    get :info
    get :boom_with_names
    get :demo
    get ':saller_code', to: 'orders#boom'
    # get :generate_full
  end
  get :ac, to: redirect('http://actionpay.ru/ref:NzI2MzEzODk1MjM3')
  get :ad, to: redirect('https://www.admitad.com/ru/promo/?ref=6192568b1c')
  root to: "orders#new"
end
