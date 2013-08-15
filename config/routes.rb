SocratesApi::Application.routes.draw do
  namespace :v1 do
    resources :users
  end
end
