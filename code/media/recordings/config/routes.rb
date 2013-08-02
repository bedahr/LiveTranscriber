resources :recordings do
  get :my, :on => :collection

  get :segments, :on => :member

  post :import_segments, :on => :member
  post :import_words,    :on => :member

  post :prepare,       :on => :member
end
