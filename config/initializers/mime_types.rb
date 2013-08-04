# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone

Mime::Type.register "text/plain",        :txt
Mime::Type.register "text/plain",        :transcription

Mime::Type.register "text/vtt",          :vtt
Mime::Type.register "text/event-stream", :sse
