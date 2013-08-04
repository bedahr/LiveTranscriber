resources :speakers do
  post :activate,                :on => :member
  post :initialize_speech_model, :on => :member
end
