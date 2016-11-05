Rails.application.routes.draw do

  resources :key_exchanger, only: [] do
    collection do
      get  'get_public'
      post 'send_public'
    end
  end

end
