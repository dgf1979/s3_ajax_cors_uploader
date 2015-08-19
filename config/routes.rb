ImgUpload::Application.routes.draw do
  root to: 'examples#index'
  resources :examples do
    resources :photos
  end
end
