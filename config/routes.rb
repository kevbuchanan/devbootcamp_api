SocratesApi::Application.routes.draw do
  namespace :v1 do
    resources :users, :api_keys, :cohorts, :challenges, :exercises

    resources :users do
      resources :challenge_attempts
      resources :exercise_attempts
    end
  end
end
