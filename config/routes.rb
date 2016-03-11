Rails.application.routes.draw do
  root to: "home#index"
  get "/song", to: "home#song"
end
