Rails.application.routes.draw do
  root to: 'application#status'

  namespace :v1 do
    # Authentication routes
    namespace :auth do
      resources :signup, only: :create do
        collection do
          post :google
          post :facebook
        end
      end
    end
  end
end
