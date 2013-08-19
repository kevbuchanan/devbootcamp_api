SocratesApi::Application.routes.draw do
  namespace :v1 do
    resources :users, :api_keys, :cohorts

    resources :users do
      resources :challenge_attempts
    end
  end
end
