@extensions ||= Core::Extension.activate_many! do |extensions|
  extensions << 'core/dashboard'
  extensions << 'core/users'

  extensions << 'media/recordings'
  extensions << 'media/languages'
  extensions << 'media/speakers'

  extensions << 'workflow/live_transcriber'

  extensions << 'asr/speech_recognizer'
end
