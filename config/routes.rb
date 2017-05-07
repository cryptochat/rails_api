Rails.application.routes.draw do

  devise_for :admins
  mount PgHero::Engine, at: :pghero
  mount ActionCable.server => '/cable'

  namespace :admin do
    root 'users#index'
    resources :users, except: %i(show)
    resources :admins, except: %i(show)
  end

  namespace :api do
    namespace :v1 do
      resources :key_exchanger, only: [] do
        collection do
          get  :get_public
          get  :verify_shared_key
          post :send_public
        end
      end

      resources :users, only: %i[index create] do
        collection do
          post :auth
          put  :update
        end
      end

      resources :chat_messages, only: %i[index] do
        collection do
          get :chat_list
        end
      end
    end
  end
end
