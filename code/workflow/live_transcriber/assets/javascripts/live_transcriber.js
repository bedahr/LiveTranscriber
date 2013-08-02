(function( $ ) {
  $.widget( "speech.liveTranscriber", {

    audio:        null,
    root:         null,
    event_source: null,

    options: { },

    _init: function() {
      var self    = this;
      this.audio  = this.element.find('audio')[0];
      this.root   = this.element;

      self._log("LiveTranscriber starting ...");

      this.event_source = new EventSource(this.root.find('a#event_source').attr('href'));

      this.event_source.addEventListener('started', function(e) {
        $("#status").removeClass('label-important').addClass('label-success');
        self._log("LiveTranscriber started!");
      });

      this.event_source.addEventListener('terminated', function(e) {
        self._log(e.data);
        self._log("LiveTranscriber terminated.");
        $("#status").removeClass('label-success').addClass('label-important');

        self.event_source.close();
      });

      this.event_source.addEventListener('log', function(e) {
        self._log(e.data);
      });

      this.event_source.addEventListener('partial_hypothese', function(e) {
        self._log(e.data);
        data = JSON.parse(e.data);
        $("#partial_hypothese").text(data.text);
      });

      this.event_source.addEventListener('transcript', function(e) {
        self._log("Received Transcript");
        self._log(e.data);

        data = JSON.parse(e.data);

        $('<p class="transcript">').text(data.text).appendTo(".editor");
        $("#partial_hypothese").text("");

        $(document).scrollTo( $(".transcript:last"), { duration:500, easing:'swing', offset: {left:0,top:-150} } );

        $(".buttons").css('visibility', 'visible');

        var track = self.audio.textTracks[0];

        if (!track) {
          self._log("Adding Text Track");
          track = self.audio.addTextTrack('metadata');
        }

        var cue = new TextTrackCue(data.start_time, data.end_time, data.text);
        cue.pauseOnExit = true

        track.addCue(cue);

        self.audio.currentTime = cue.startTime;
        self.audio.play();
      });

    },

    _log: function(msg) {
      console.log(msg);
      console.log(this.player);
      $('<div/>').text(msg).prependTo(this.root.find("#log"));
    }

  });
}( jQuery ) );

$(document).ready(function() {

  // Hide buttons on click
  $("#live_transcriber .buttons a").click( function() { $(".buttons").css('visibility', 'hidden') });

  // HTML5 editor
  // $("#live_transcriber div.editor").hallo();

  // LiveTranscriber
  // $("#live_transcriber").liveTranscriber();

});
