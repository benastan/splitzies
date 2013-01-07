$search_friends = $ '#search_friends'
$friends = $ '.friend'
$invitees = $ '.invitees'
$invite_friends_form = $ '#invite_friends'
$notice = $ '.notice'
invitees = []

$search_friends.keyup ->
  val = this.value.toLowerCase()
  length = val.length
  $matches = $friends.filter (index, i) -> i.getAttribute('data-name').toLowerCase().indexOf(val) isnt -1
  $friends.hide()
  $matches.show()

update_invitees = ->
  friends = []
  $friends.filter('.active').each -> friends.push this.getAttribute 'data-name'
  friends.join ', '

$friends.each ->
  $friend = $ this
  active = false
  $friend.click ->
    $friend[if active = !active == true then 'addClass' else 'removeClass']('active')
    $invitees.html update_invitees()
    id = $friend.data('facebook-id')
    if active
      invitees.push id
    else
      index = invitees.indexOf(id)
      invitees.splice index, 1
$invite_friends_form.submit ->
  ui = 
    message: "Help keep our household organized"
    to: invitees
    method: 'apprequests'
  FB.ui ui, (requests) ->
    $.ajax
      type: 'post'
      url: '/invites.json'
      data: requests
      success: (invites, status, xhr) ->
        ii = invites.length
        html = ''
        if ii > 0
          html = "<i class='icon icon-ok'></i> Invited #{invites.length} friends."
        else
          html = "<i class='icon icon-remove'></i> Looks like you already invited those people."
        html = "#{html} <a href='/users' class='btn btn-primary' id='redirect_to_default_path'>Continue &rarr;</a>"
        $notice.html html
        $.ajax
          type: 'get'
          url: '/users/next_step.json'
          success: (user, status, xhr) ->
            $('#redirect_to_default_path').attr('href', xhr.getAllResponseHeaders().match(/(?:Location: (\S+))/)[1])
  false
