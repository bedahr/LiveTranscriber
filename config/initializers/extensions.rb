@extensions ||= Core::Extension.activate_many! do |extensions|
  extensions << 'core/dashboard'
  extensions << 'core/users'

  extensions << 'media/recordings'
  extensions << 'media/languages'
  extensions << 'media/words'
  extensions << 'media/segments'
  extensions << 'media/transcriptions'
  extensions << 'media/reviewed_transcriptions'

  extensions << 'workflow/transcriber'
  extensions << 'workflow/reviewer'

  #extensions << 'experimental/talkbox'
  #extensions << 'media/speakers'
  #extensions << 'workflow/live_transcriber'

  extensions << 'asr/speech_recognizer'
end
