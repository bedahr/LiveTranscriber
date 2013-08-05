$(document).ready(function() {

  // Continue to next page
  // TODO: Indicate whether audio is still playing (useful if there is a silence) ...
  $("#transcriber .continue").click( function() {
    if ( $(".segment").not('.saved').length > 0 ) {
      alert("There are unsaved segments");
      return(false);
    }
  })

  // Next Segment
  $("#transcriber .next_segment").click( function(e) {
    console.log("next ..");

    var next_segment = $(".segment:hidden:first");

    if (next_segment.length == 0) {
      $(".continue").show();
      $(".next_segment").hide();
      $(".preview").text("");
    } else {
      next_segment.show().trigger('focus').trigger('play');
      $(".preview").text( next_segment.data('next-segment-preview') );
    }

    e.preventDefault();
    e.stopPropagation();
  });

  // Replay clip
  // TODO: Implement better selection of what to play, e.g. last selected segment
  $("#transcriber .replay").click( function(e) {
    console.log("replay clip");

    $(".segment:visible:last").trigger('play');

    e.preventDefault();
    e.stopPropagation();
  });

  // Remove Transcription
  $("#transcriber .remove_transcription").on('ajax:success', function() {
    $(this).closest('.transcription').hide();
  });

  // TODO: Sometimes clips are not played. Find out why ...
  $("#transcriber .segment").on('play', function() {
    var audio = $("audio")[0];
    var track = audio.textTracks[0];
    var cue   = track.cues.getCueById($(this).attr('id'));

    console.log("playing cue");
    console.log(cue);

    $.each(track.cues, function(i,e) { e.pauseOnExit = false } );

    if (cue)
      cue.pauseOnExit = true;

    audio.pause();
    audio.currentTime = $(this).data('start-time');
    audio.play();
  } );

  // 'save' event for segment
  $("#transcriber .segment").on('save', function() {
    var segment = $(this);

    console.log("Saving transcription: " + segment.attr('id') );

    segment.removeClass('failed');
    $(".alert").hide();

    $.post( $(".editor").attr('action'),
            { transcription: { segment_id: segment.data('id'), html_body: segment.html() } },
            function(data) {
              console.log("transcription saved");
              segment.addClass('saved');
            } )

    .fail(function(data) { segment.addClass("failed"); $(".alert").text(data.responseText).show(); }) ;
  });

  // Cue Change
  $("#transcriber audio track").on('cuechange', function() {
    $( this.track.activeCues ).each( function(i, cue) {
      console.log("cue changed: " + cue.id + " - " + cue.pauseOnExit);
      $("#" + cue.id).addClass('active');
    });
  });

  // Keycodes
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

  // Audio has loaded
  $("#transcriber audio").on('canplay', function() {
    console.log("meta data loaded. showing first segment ...");

    $('#transcriber .existing_transcriptions').find('tr').each( function(i, element) {
      console.log( element );
      $( $(element).data('target') ).remove();
    });

    $(".streaming").hide();
    $(".next_segment").show();
    $(".replay").show();
    $(".next_segment").trigger('click');
  });

  // Transcriber
  $('#transcriber .segment .line').hallo({
    plugins: {
      'hallotranscriber': {}
    }
  });

  // Editor selected
  // TODO: Implement support for multi word spanning ranges
  $('#transcriber .editor').bind('halloselected', function(event, data) {
    console.log("halloselected");

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

    $(event.target).removeClass('saved');
  });

  // Editor activated
  $('#transcriber .editor').bind('halloactivated', function(event, data) {
    $(event.target).closest('.segment').removeClass('saved');
  });

  // Editor deactivated
  $('#transcriber .editor').bind('hallodeactivated', function(event, data) {
    $(event.target).trigger('save');
  });

});
