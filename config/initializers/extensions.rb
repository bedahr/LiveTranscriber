@extensions ||= Core::Extension.activate_many! do |extensions|
  extensions << 'core/dashboard'
  extensions << 'core/users'

  extensions << 'media/recordings'
  extensions << 'media/languages'
  extensions << 'media/speakers'
  extensions << 'media/words'
  extensions << 'media/segments'
  extensions << 'media/transcriptions'
  extensions << 'media/reviewed_transcriptions'

  extensions << 'workflow/transcriber'
  extensions << 'workflow/live_transcriber'
  extensions << 'workflow/reviewer'

  extensions << 'asr/speech_recognizer'
end
