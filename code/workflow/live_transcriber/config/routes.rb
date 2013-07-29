get  "/live_transcriber/:id"         => "live_transcriber#index"
get  "/live_transcriber/:id/:action" => "live_transcriber"
post "/live_transcriber/:id/:action" => "live_transcriber"
