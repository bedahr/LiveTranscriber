LiveTranscriber::Application.routes.draw do
  Core::Extension.inject_routes!(self)
end
