###
Hallo {{ VERSION }} - a rich text editing jQuery UI widget
(c) 2011 Henri Bergius, IKS Consortium
Hallo may be freely distributed under the MIT license
http://hallojs.org
###
((jQuery) ->
  # Hallo provides a jQuery UI widget `hallo`. Usage:
  #
  #     jQuery('p').hallo();
  #
  # Getting out of the editing state:
  #
  #     jQuery('p').hallo({editable: false});
  #
  # When content is in editable state, users can just click on
  # an editable element in order to start modifying it. This
  # relies on browser having support for the HTML5 contentEditable
  # functionality, which means that some mobile browsers are not
  # supported.
  #
  # If plugins providing toolbar buttons have been enabled for
  # Hallo, then a toolbar will be rendered when an area is active.
  #
  # ## Toolbar
  #
  # Hallo ships with different toolbar options, including:
  #
  # * `halloToolbarContextual`: a toolbar that appears as a popover
  #   dialog when user makes a selection
  # * `halloToolbarFixed`: a toolbar that is constantly visible above
  #   the editable area when the area is activated
  #
  # The toolbar can be defined by the `toolbar` configuration key,
  # which has to conform to the toolbar widget being used.
  #
  # Just like with plugins, it is possible to use Hallo with your own
  # custom toolbar implementation.
  #
  # ## Events
  #
  # The Hallo editor provides several jQuery events that web
  # applications can use for integration:
  #
  # ### Activated
  #
  # When user activates an editable (usually by clicking or tabbing
  # to an editable element), a `halloactivated` event will be fired.
  #
  #     jQuery('p').on('halloactivated', function() {
  #         console.log("Activated");
  #     });
  #
  # ### Deactivated
  #
  # When user gets out of an editable element, a `hallodeactivated`
  # event will be fired.
  #
  #     jQuery('p').on('hallodeactivated', function() {
  #         console.log("Deactivated");
  #     });
  #
  # ### Modified
  #
  # When contents in an editable have been modified, a
  # `hallomodified` event will be fired.
  #
  #     jQuery('p').on('hallomodified', function(event, data) {
  #         console.log("New contents are " + data.content);
  #     });
  #
  # ### Restored
  #
  # When contents are restored through calling
  # `.hallo("restoreOriginalContent")` or the user pressing ESC while
  # the cursor is in the editable element, a 'hallorestored' event will
  # be fired.
  #
  #     jQuery('p').on('hallorestored', function(event, data) {
  #         console.log("The thrown contents are " + data.thrown);
  #         console.log("The restored contents are " + data.content);
  #     });
  #
  jQuery.widget 'IKS.hallo',
    toolbar: null
    bound: false
    originalContent: ''
    previousContent: ''
    uuid: ''
    selection: null
    _keepActivated: false
    originalHref: null

    options:
      editable: true
      plugins: {}
      toolbar: 'halloToolbarContextual'
      parentElement: 'body'
      buttonCssClass: null
      toolbarCssClass: null
      toolbarPositionAbove: false
      toolbarOptions: {}
      placeholder: ''
      forceStructured: true
      checkTouch: true
      touchScreen: null

    _create: ->
      @id = @_generateUUID()

      @checkTouch() if @options.checkTouch and @options.touchScreen is null

      for plugin, options of @options.plugins
        options = {} unless jQuery.isPlainObject options
        jQuery.extend options,
          editable: this
          uuid: @id
          buttonCssClass: @options.buttonCssClass
        jQuery(@element)[plugin] options

      @element.one 'halloactivated', =>
        # We will populate the toolbar the first time this
        # editable is activated. This will make multiple
        # Hallo instances on same page load much faster
        @_prepareToolbar()

      @originalContent = @getContents()

    _init: ->
      if @options.editable
        @enable()
      else
        @disable()

    destroy: ->
      @disable()

      if @toolbar
        @toolbar.remove()
        @element[@options.toolbar] 'destroy'

      for plugin, options of @options.plugins
        jQuery(@element)[plugin] 'destroy'

      jQuery.Widget::destroy.call @

    # Disable an editable
    disable: ->
      @element.attr "contentEditable", false
      @element.off "focus", @_activated
      @element.off "blur", @_deactivated
      @element.off "keyup paste change", @_checkModified
      @element.off "keyup", @_keys
      @element.off "keyup mouseup", @_checkSelection
      @bound = false

      jQuery(@element).removeClass 'isModified'
      jQuery(@element).removeClass 'inEditMode'

      @element.parents('a').addBack().each (idx, elem) =>
        element = jQuery elem
        return unless element.is 'a'
        return unless @originalHref
        element.attr 'href', @originalHref

      @_trigger "disabled", null

    # Enable an editable
    enable: ->
      @element.parents('a[href]').addBack().each (idx, elem) =>
        element = jQuery elem
        return unless element.is 'a[href]'
        @originalHref = element.attr 'href'
        element.removeAttr 'href'

      @element.attr "contentEditable", true

      unless jQuery.parseHTML(@element.html())
        @element.html this.options.placeholder
        @element.css
          'min-width': @element.innerWidth()
          'min-height': @element.innerHeight()

      unless @bound
        @element.on "focus", this, @_activated
        @element.on "blur", this, @_deactivated
        @element.on "keyup paste change", this, @_checkModified
        @element.on "keyup", this, @_keys
        @element.on "keyup mouseup", this, @_checkSelection
        @bound = true

      @_forceStructured() if @options.forceStructured

      @_trigger "enabled", null

    # Activate an editable for editing
    activate: ->
      @element.focus()

    # Checks whether the editable element contains the current selection
    containsSelection: ->
      range = @getSelection()
      return @element.has(range.startContainer).length > 0

    # Only supports one range for now (i.e. no multiselection)
    getSelection: ->
      sel = rangy.getSelection()
      range = null
      if sel.rangeCount > 0
        range = sel.getRangeAt(0)
      else
        range = rangy.createRange()
      return range

    restoreSelection: (range) ->
      sel = rangy.getSelection()
      sel.setSingleRange(range)

    replaceSelection: (cb) ->
      if navigator.appName is 'Microsoft Internet Explorer'
        t = document.selection.createRange().text
        r = document.selection.createRange()
        r.pasteHTML(cb(t))
      else
        sel = window.getSelection()
        range = sel.getRangeAt(0)
        newTextNode = document.createTextNode(cb(range.extractContents()))
        range.insertNode(newTextNode)
        range.setStartAfter(newTextNode)
        sel.removeAllRanges()
        sel.addRange(range)

    removeAllSelections: () ->
      if navigator.appName is 'Microsoft Internet Explorer'
        range.empty()
      else
        window.getSelection().removeAllRanges()

    getPluginInstance: (plugin) ->
      # jQuery UI 1.10 or newer
      instance = jQuery(@element).data "IKS-#{plugin}"
      return instance if instance
      # Older jQuery UI
      return jQuery(@element).data plugin

    # Get contents of an editable as HTML string
    getContents: ->
      for plugin of @options.plugins
        cleanup = @getPluginInstance(plugin).cleanupContentClone
        continue unless jQuery.isFunction cleanup
        jQuery(@element)[plugin] 'cleanupContentClone', @element
      @element.html()

    # Set the contents of an editable
    setContents: (contents) ->
      @element.html contents

    # Check whether the editable has been modified
    isModified: ->
      @previousContent = @originalContent unless @previousContent
      @previousContent isnt @getContents()

    # Set the editable as unmodified
    setUnmodified: ->
      jQuery(@element).removeClass 'isModified'
      @previousContent = @getContents()

    # Set the editable as modified
    setModified: ->
      jQuery(@element).addClass 'isModified'
      @._trigger 'modified', null,
        editable: @
        content: @getContents()

    # Restore the content original
    restoreOriginalContent: () ->
      @element.html(@originalContent)

    # Execute a contentEditable command
    execute: (command, value) ->
      if document.execCommand command, false, value
        @element.trigger "change"

    protectFocusFrom: (el) ->
      el.on "mousedown", (event) =>
        event.preventDefault()
        @_protectToolbarFocus = true
        setTimeout =>
          @_protectToolbarFocus = false
        , 300

    keepActivated: (@_keepActivated) ->

    _generateUUID: ->
      S4 = ->
        ((1 + Math.random()) * 0x10000|0).toString(16).substring 1
      "#{S4()}#{S4()}-#{S4()}-#{S4()}-#{S4()}-#{S4()}#{S4()}#{S4()}"

    _prepareToolbar: ->
      @toolbar = jQuery('<div class="hallotoolbar"></div>').hide()
      @toolbar.addClass @options.toolbarCssClass if @options.toolbarCssClass

      defaults =
        editable: @
        parentElement: @options.parentElement
        toolbar: @toolbar
        positionAbove: @options.toolbarPositionAbove

      toolbarOptions = jQuery.extend({}, defaults, @options.toolbarOptions)
      @element[@options.toolbar] toolbarOptions

      for plugin of @options.plugins
        populate = @getPluginInstance(plugin).populateToolbar
        continue unless jQuery.isFunction populate
        @element[plugin] 'populateToolbar', @toolbar

      @element[@options.toolbar] 'setPosition'
      @protectFocusFrom @toolbar

    changeToolbar: (element, toolbar, hide = false) ->
      originalToolbar = @options.toolbar

      @options.parentElement = element
      @options.toolbar = toolbar if toolbar

      return unless @toolbar
      @element[originalToolbar] 'destroy'
      do @toolbar.remove
      do @_prepareToolbar

      @toolbar.hide() if hide

    _checkModified: (event) ->
      widget = event.data
      widget.setModified() if widget.isModified()

    _keys: (event) ->
      widget = event.data
      if event.keyCode == 27
        old = widget.getContents()
        widget.restoreOriginalContent(event)
        widget._trigger "restored", null,
          editable: widget
          content: widget.getContents()
          thrown: old

        widget.turnOff()

    _rangesEqual: (r1, r2) ->
      return false unless r1.startContainer is r2.startContainer
      return false unless r1.startOffset is r2.startOffset
      return false unless r1.endContainer is r2.endContainer
      return false unless r1.endOffset is r2.endOffset
      true

    # Check if some text is selected, and if this selection has changed.
    # If it changed, trigger the "halloselected" event
    _checkSelection: (event) ->
      if event.keyCode == 27
        return

      widget = event.data

      # The mouseup event triggers before the text selection is updated.
      # I did not find a better solution than setTimeout in 0 ms
      setTimeout ->
        sel = widget.getSelection()
        if widget._isEmptySelection(sel) or widget._isEmptyRange(sel)
          if widget.selection
            widget.selection = null
            widget._trigger "unselected", null,
              editable: widget
              originalEvent: event
          return

        if !widget.selection or not widget._rangesEqual sel, widget.selection
          widget.selection = sel.cloneRange()
          widget._trigger "selected", null,
            editable: widget
            selection: widget.selection
            ranges: [widget.selection]
            originalEvent: event
      , 0

    _isEmptySelection: (selection) ->
      if selection.type is "Caret"
        return true
      return false

    _isEmptyRange: (range) ->
      if range.collapsed
        return true
      if range.isCollapsed
        return range.isCollapsed() if typeof range.isCollapsed is 'function'
        return range.isCollapsed

      return false

    turnOn: () ->
      if this.getContents() is this.options.placeholder
        this.setContents ''

      jQuery(@element).addClass 'inEditMode'
      @_trigger "activated", null, @

    turnOff: () ->
      jQuery(@element).removeClass 'inEditMode'
      @_trigger "deactivated", null, @

      unless @getContents()
        @setContents @options.placeholder

    _activated: (event) ->
      event.data.turnOn()

    _deactivated: (event) ->
      return if event.data._keepActivated

      unless event.data._protectToolbarFocus is true
        event.data.turnOff()
      else
        setTimeout ->
          jQuery(event.data.element).focus()
        , 300

    _forceStructured: (event) ->
      try
        document.execCommand 'styleWithCSS', 0, false
      catch e
        try
          document.execCommand 'useCSS', 0, true
        catch e
          try
            document.execCommand 'styleWithCSS', false, false
          catch e

    checkTouch: ->
      @options.touchScreen = !!('createTouch' of document)

)(jQuery)



#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
#
#     Contextual toolbar plugin
((jQuery) ->
  jQuery.widget 'IKS.halloToolbarContextual',
    toolbar: null

    options:
      parentElement: 'body'
      editable: null
      toolbar: null
      positionAbove: false

    _create: ->
      @toolbar = @options.toolbar
      jQuery(@options.parentElement).append @toolbar

      @_bindEvents()

      jQuery(window).resize (event) =>
        @_updatePosition @_getPosition event

    _getPosition: (event, selection) ->
      return unless event
      eventType = event.type
      switch eventType
        when 'keydown', 'keyup', 'keypress'
          return @_getCaretPosition selection
        when 'click', 'mousedown', 'mouseup'
          return position =
            top: event.pageY
            left: event.pageX

    _getCaretPosition: (range) ->
      tmpSpan = jQuery "<span/>"
      newRange = rangy.createRange()
      newRange.setStart range.endContainer, range.endOffset
      newRange.insertNode tmpSpan.get 0

      position =
        top: tmpSpan.offset().top
        left: tmpSpan.offset().left
      tmpSpan.remove()

      return position

    setPosition: ->
      unless @options.parentElement is 'body'
        # Floating toolbar, move to body
        @options.parentElement = 'body'
        jQuery(@options.parentElement).append @toolbar

      @toolbar.css 'position', 'absolute'
      @toolbar.css 'top', @element.offset().top - 20
      @toolbar.css 'left', @element.offset().left

    _updatePosition: (position, selection=null) ->
      return unless position
      return unless position.top and position.left

      # In case there is a selection, move toolbar on top of it and align with
      # start of selection.
      # Else move it on top of current position, center it and move
      # it slightly to the right.
      toolbar_height_offset = this.toolbar.outerHeight() + 10
      if selection and !selection.collapsed and selection.nativeRange
        selectionRect = selection.nativeRange.getBoundingClientRect()
        if this.options.positionAbove
          top_offset = selectionRect.top - toolbar_height_offset
        else
          top_offset = selectionRect.bottom + 10

        top = jQuery(window).scrollTop() + top_offset
        left = jQuery(window).scrollLeft() + selectionRect.left
      else
        if this.options.positionAbove
          top_offset = -10 - toolbar_height_offset
        else
          top_offset = 20
        top = position.top + top_offset
        left = position.left - @toolbar.outerWidth() / 2 + 30
      @toolbar.css 'top', top
      @toolbar.css 'left', left

    _bindEvents: ->
      # show the toolbar when clicking the element
      @element.on 'click', (event, data) =>
        position = {}
        scrollTop = $('window').scrollTop()
        position.top = event.clientY + scrollTop
        position.left = event.clientX
        @_updatePosition(position, null)
        if @toolbar.html() != ''
          @toolbar.show()

      # catch select -> show (and reposition?)
      @element.on 'halloselected', (event, data) =>
        position = @_getPosition data.originalEvent, data.selection
        return unless position
        @_updatePosition position, data.selection
        if @toolbar.html() != ''
          @toolbar.show()

      # catch deselect -> hide
      @element.on 'hallounselected', (event, data) =>
        @toolbar.hide()

      @element.on 'hallodeactivated', (event, data) =>
        @toolbar.hide()
) jQuery
