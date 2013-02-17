UsersLogic =
  email_friends: ->
    $email_invites = $ '#invite_email'
    return unless $email_invites.length

    $form = $email_invites.find('#new_invite')
    $emails = $form.find('#invites_email_addresses')
    $success = $('#success_msg')
    $success_recipients = $('#email_recipients')
    $error_box = $form.find '.error_box'
    $go_home_btn = $('#go_home_btn')

    render_invites = (invites) ->
      $success.toggleClass('hide', false)
      $success_recipients.html(_(invites).collect((i) -> i.email).join(', '))
      $go_home_btn.toggleClass('hide', false)

    error_tpl = _.template "<p class=\"error\"><b><%= email %></b> <%= error_text %></p>"

    $form.on 'better_validation:invalid', (e, errors, xhr) ->
      text = []
      _(errors).each (v, k) ->
        text.push error_tpl
          email: k,
          error_text: "is already a user."
      $error_box.toggleClass('hide', false).html(text.join(''))
      $emails.val(_(errors).keys().join(', '))

      if xhr
        invites = $.parseJSON(xhr.responseText)
        render_invites invites

    window.email_invites_sent = (invites) ->
      $error_box.toggleClass('hide')
      render_invites invites
      $emails.val('')

  facebook_friends: ->
    $search_friends = $ '#search_friends'
    return unless $search_friends.length
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
run UsersLogic
