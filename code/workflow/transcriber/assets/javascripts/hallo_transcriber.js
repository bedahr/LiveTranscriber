(function(jQuery) {
  return jQuery.widget("IKS.hallotranscriber", {
    playButton: null,
    unsureButton: null,
    alternativesElement: null,
    actionsElement: null,

    options: {
      uuid: '',
      editable: null
    },
    _create: function() {},
    populateToolbar: function(toolbar) {
      console.log("populate toolbar called");

      this.alternativesElement = $("<span></span>").addClass('alternatives').addClass('btn-group').text("alt");
      this.actionsElement = $("<span>").addClass('btn-group');

      // TODO: Is there a better name instead of "Unsure"?
      this.unsureButton = $("<span class='btn' title='Indecipherable or Unsure about Spelling\n'><span class='unsure'>Unsure</span></span>").tooltip({placement:'bottom'});
      this.unsureButton.click( function() {
        var sel = window.getSelection();
        var range = sel.getRangeAt(0);
        var selectedNode = $(range.startContainer.parentNode);

        selectedNode.toggleClass('unsure');
      });

      // TODO: Consider whether to play only selected word or whole clip!
      this.playButton = $("<span class='btn'><i class='icon-play'></i></span>");
      this.playButton.click(function() {
        var sel = window.getSelection();
        var range = sel.getRangeAt(0);
        var selectedNode = $(range.startContainer.parentNode);

        selectedNode.closest('.segment').trigger('play');
      });

      this.actionsElement.append(this.playButton).append(this.unsureButton);

      toolbar.addClass('btn-toolbar');

      return toolbar.append(this.alternativesElement).append(this.actionsElement);
    },
    cleanupContentClone: function(element) {}
  });
})(jQuery);
