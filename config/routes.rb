Rails.application.routes.draw do



  devise_for :devices
  get '/webcam', to: 'main#webcam'
  get '/spaceapi', to: 'main#spaceapi', defaults: {format: 'json'}

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/  do
    root 'main#index'
    devise_for :users

    resources :projects
    resources :news
    resources :devices, only: [:index, :show]
    resources :users, path: 'hackers', controller: 'hackers', only: [:index, :show, :edit, :update]

    get '/rules', to: 'main#rules'
    get '/calendar', to: 'main#calendar'
    get '/contacts', to: 'main#contacts'
    get '/cabinet', to: 'main#cabinet'

    namespace :admin do
      resources :dashboard, only: :index
      resources :users, only: [:index, :edit, :update]
    end

    resources :events, only: [:index] do
      collection do
        get 'add'
      end
    end
  end
end
