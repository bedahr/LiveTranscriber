$(document).ready(function() {

  $("#reviewer .replay_button").click( function() {
    var audio = $("audio")[0];
    audio.currentTime = $(".segment:first").data('start-time');
    audio.play();
  })

  $("#reviewer .transcriptions .highlightable").textHighlighter({color:'#da4f49'});

  $("#reviewer .reviewed_button").click( function(e) {
    var data = {};

    e.preventDefault();

    if ( $(this).attr('disabled') )
      return;

    $(".unreviewed").hide();
    $(".reviewed").show();

    $(".segment").each( function(i,e) { data[ $(e).data('reviewed-transcription-id') ] = $(e).html() } );

    $.post( $("#form").attr('action'),
            { reviewed_transcriptions: data },
            function(data) {
              console.log("reviewed transcriptions saved");
              window.location = $(".next_page a").attr('href')
            } )
    .fail(function() { alert("Review could not be saved!"); }) ;
  });

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

    last_cue.onexit = function() {
      console.log("last cue reached");
      $(".reviewed_button").attr('disabled', false).addClass('btn-info');
      audio.pause();
    };

    console.log(last_cue);

    audio.currentTime = $(".segment:first").data('start-time');
    audio.play();
  });

});
