(->
  $notifications = $ '.notification'
  return unless $notifications.length

  $notifications.each ->
    $notification = $ this
    id = $notification.data 'id'
    $notification.click ->
      delete_notification = $.ajax
        type: 'put',
        url: "/roommate_notifications/#{id}/seen.json",
        async: false
      delete_notification.status == 200
  )()
