require_relative '../lib/wiki_gateway'
Rails.application.routes.draw do

  resources :settings
  root 'main#index'

  devise_for :devices
  devise_for :users

  resources :projects
  resources :news
  resources :devices, only: [:index, :show]
  resources :users, path: 'hackers', controller: 'hackers', only: [:index, :show, :edit, :update] do
    member do
      post 'add_mac', to: 'hackers#add_mac'
      delete 'remove_mac', to: 'hackers#remove_mac'
    end

    collection do
      get 'find', to: 'hackers#find_by_mac'
      post 'detected', to: 'hackers#detected_at_hackerspace'
    end
  end
  resources :thanks

  get '/rules', to: 'main#rules'
  get '/calendar', to: 'main#calendar'
  get '/contacts', to: 'main#contacts'
  get '/procedure', to: 'main#procedure'
  get '/board', to: 'main#board'
  get '/tariffs', to: 'main#tariffs'
  get '/howtopay', to: 'main#howtopay'
  get '/chart', to: 'main#chart'
  get '/useful', to: 'hackers#useful'

  get '/spaceapi', to: 'main#spaceapi', defaults: {format: 'json'}

  authenticate :user do
    mount WikiGateway, at: 'wiki'
  end

  namespace :admin do
    resources :dashboard, only: :index
    resources :users, only: [:new, :create]
    resources :payments
    resources :erip_transactions
    resources :bank_transactions
    post "bank_transactions/mass_update", to: "bank_transactions#mass_update"
    post "erip_transactions/bepaid_notify", to: "erip_transactions#bepaid_notify"
  end

  resources :events, only: [:index] do
    collection do
      get 'add'
    end
  end
end
