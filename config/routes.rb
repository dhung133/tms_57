Rails.application.routes.draw do
  root "static_pages#home"
  get "about" => "static_pages#about"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  resources :users, only: [:show, :edit, :update] do
    resources :relationships, only: [:index]
  end
  resources :reports, only: [:index, :create]
  resources :relationships, only: [:create, :destroy]
  resources :courses, only: [:index, :show] do
    resources :user_subjects, only: [:show, :update] do
      resource :finish_subject, only: [:update]
    end
  end
  namespace :supervisor do
    resources :users
    resources :subjects
    resources :courses do
      resources :course_subjects, only: [:show] do
        resource :active_subjects, only: [:update]
      end
      resource :active_courses, only: [:update]
    end
    resources :user_courses, only: :destroy
    resources :assign_trainees, only: [:edit, :update]
  end
end
