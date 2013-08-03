$(document).ready(function() {

  // TODO: Indicate whether audio is still playing (useful if there is a silence) ...

  $("#transcriber .continue").click( function() {
    if ( $(".segment").not('.saved').length > 0 ) {
      alert("There are unsaved segments");
      return(false);
    }
  })

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

    console.log("playing cue");
    console.log(cue);

    $.each(track.cues, function(i,e) { e.pauseOnExit = false } );

    cue.pauseOnExit   = true;

    audio.pause();
    audio.currentTime = $(this).data('start-time');
    audio.play();
  } );

  $("#transcriber .segment").on('save', function() {
    var segment = $(this);

    console.log("Saving transcription: " + segment.attr('id') );

    $.post( segment.attr('action'),
            { transcription: { segment_id: segment.data('id'), html_body: segment.html() } },
            function(data) {
              console.log("transcription saved");
              segment.addClass('saved');
            } )

    .fail(function() { alert("Segment could not be saved!"); }) ;
  });

  $("#transcriber audio track").on('cuechange', function() {
    // $(".segment.active").removeClass('active');

    $( this.track.activeCues ).each( function(i, cue) {
      console.log("cue changed: " + cue.id + " - " + cue.pauseOnExit);
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

    $('#transcriber .existing_transcriptions').find('li').each( function(i, element) {
      console.log( element );
      $( $(element).data('target') ).remove();
    });

    $(".streaming").hide();
    $(".next_segment").show();
    $(".replay").show();
    $(".next_segment").trigger('click');
  });

  // Transcriber
  $('#transcriber .segment').hallo({
    plugins: {
      'hallotranscriber': {}
    }
  });

  // On selected
  $('#transcriber .editor').bind('halloselected', function(event, data) {
    console.log("halloselected");

    sel = window.getSelection();
    range = sel.getRangeAt(0);

    $(".alternatives").html("");

    // TODO: Implement support for multi word spanning ranges
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

  $('#transcriber .editor').bind('halloactivated', function(event, data) {
    $(event.target).removeClass('saved');
  });

  $('#transcriber .editor').bind('hallodeactivated', function(event, data) {
    $(event.target).trigger('save');
  });

});
