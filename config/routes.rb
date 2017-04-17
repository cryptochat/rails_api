Rails.application.routes.draw do

  mount PgHero::Engine, at: :pghero
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do

      resources :key_exchanger, only: [] do
        collection do
          get  :get_public
          post :send_public
        end
      end

      resources :users do
        collection do
          post :auth
        end
      end

    end
  end

end
