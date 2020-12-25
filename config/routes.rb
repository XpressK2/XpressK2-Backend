Rails.application.routes.draw do
  namespace :v1 do
    # Authentication routes
    namespace :auth do
      resources :signup, only: :create
    end
  end
end
