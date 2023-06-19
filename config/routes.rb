Rails.application.routes.draw do
  resources :shorteners,except: [:show,:destroy]
  get 'shorteners/:short_url' => 'shorteners#show'#,via: [:get, :post]
  delete 'shorteners/:short_url' => 'shorteners#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "shorteners#new"
end
