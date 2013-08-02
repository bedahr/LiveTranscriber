$(document).ready(function() {

  // TODO: Indicate whether audio is still playing (useful if there is a silence) ...

  $("#transcriber .next_segment").click( function(e) {
    console.log("next ..");

    var next_segment = $(".segment:hidden:first");

    if (next_segment.length == 0) {
      $(".continue").show();
      $(".next_segment").hide();
      $(".preview").text("");
    } else {
      next_segment.show().trigger('play');
      $(".preview").text( next_segment.data('next-segment-preview') );
    }

    e.preventDefault();
    e.stopPropagation();
  });

  $("#transcriber .replay").click( function(e) {
    console.log("replay clip");

    // TODO: Implement better selection of what to play, e.g. last selected segment
    $(".segment:visible:last").trigger('play');

    e.preventDefault();
    e.stopPropagation();
  });

  // TODO: Sometimes clips are not played. Find out why ...
  $("#transcriber .segment").on('play', function() {
    var audio = $("audio")[0];
    var track = audio.textTracks[0];
    var cue   = track.cues.getCueById($(this).attr('id'));

    console.log(cue);

    $.each(track.cues, function(i,e) { e.pauseOnExit = false } );

    cue.pauseOnExit   = true;

    audio.pause();
    audio.currentTime = $(this).data('start-time');
    audio.play();
  } );

  $('#transcriber .editor').bind('halloselected', function(event, data) {
      console.log("halloselected");

      console.log( $(".hallotoolbar:visible") );

      sel = window.getSelection();
      range = sel.getRangeAt(0);

      $(".alternatives").html("");

      var selectedNode = $(range.startContainer.parentNode);

      $.each( selectedNode.data('alternatives'), function(i, alternative) {
        var btn = $("<span>").addClass('btn').text(alternative);

        btn.click( function() {
          console.log( $(this).text() );
          selectedNode.text( $(this).text() );

          $(this).closest('.hallotoolbar').hide();
        });

        $(".alternatives").append(btn);
      });

      // TODO: Implement support for multi word spanning ranges
  });

  $("#transcriber audio track").on('cuechange', function() {
    // $(".segment.active").removeClass('active');

    $( this.track.activeCues ).each( function(i, cue) {
      console.log("cue changed: " + cue.id);
      $("#" + cue.id).addClass('active');

      // TODO: Put focus on element
    });
  });

  $('#transcriber').on('keydown', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);

    console.log("key pressed: " + code);

    if ( code == 13 ) { // Enter
      console.log("Enter pressed");

      $(".next_segment").trigger('click');
      e.preventDefault();
      e.stopPropagation();

    } else if ( code == 9 ) { // Tab
      console.log("tab pressed");

      $(".replay").trigger('click');

      e.preventDefault();
      e.stopPropagation();

    }
  });

  $("#transcriber audio").on('canplay', function() {
    console.log("meta data loaded. showing first segment ...");
    $(".streaming").hide();
    $(".next_segment").show();
    $(".replay").show();
    $(".next_segment").trigger('click');
  });

  // Transcriber
  $('#transcriber .editor').hallo({
    plugins: {
      'hallotranscriber': {}
    }
  });


});
