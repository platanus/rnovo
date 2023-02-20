Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api, defaults: { format: :json } do
    namespace :internal do
      resources :terms, only: :index
      resources :trademarks, only: [] do
        collection do
          get :phonetic_search
          get :full_phonetic_search
        end
      end
    end
  end
  resources :terms, only: :index
  resources :trademarks, only: :index
  devise_for :users
  mount CoverImageUploader.derivation_endpoint => "/derivations/cover_image"
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
