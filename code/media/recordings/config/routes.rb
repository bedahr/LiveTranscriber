resources :recordings do
  get :my, :on => :collection

  post :import_labels, :on => :member
  post :import_words,  :on => :member

  post :prepare,       :on => :member
end
