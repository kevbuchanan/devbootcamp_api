SocratesApi::Application.routes.draw do
  namespace :v1 do
    resources :users
    resources :api_keys
  end
end
