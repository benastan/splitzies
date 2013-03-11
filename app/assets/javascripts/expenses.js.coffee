run
  select_roommates_widget: ->
    $widget = $ '#select_roommates_widget'
    return unless $widget.length

    $widgets = $widget.find('.roommate-checkbox')

    $widgets.each ->
      $wid = $ this
      $input = $wid.find('input[type="hidden"].included')
      active = $wid.hasClass('active')
      $wid.on 'click', ->
        active = ! active
        $wid.toggleClass('active', active)
        $input.val(active ? 't' : 'f')


