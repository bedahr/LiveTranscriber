$(document).ready(function() {

  $("#reviewer audio track").on('cuechange', function() {

    $( this.track.activeCues ).each( function(i, cue) {
      console.log("cue changed: " + cue.id);
      $("#" + cue.id).addClass('active');
    });
  });

  $("#reviewer audio").on('canplay', function() {
    console.log("meta data loaded. starting to play ...");

    $(".streaming").hide();

    var audio    = $("audio")[0];
    var last_cue = audio.textTracks[0].cues.getCueById( $(".segment:last").attr('id') );

    last_cue.pauseOnExit = true;

    audio.currentTime = $(".segment:first").data('start-time');
    audio.play();
  });

});
