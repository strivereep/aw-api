Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope :api do
    scope :v1 do
      post '/users/signup' => 'users#create'
      post '/auth/signin'

      resources :contents, only: %i[index create update destroy]
    end
  end
end
