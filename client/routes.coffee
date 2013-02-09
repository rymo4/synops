Meteor.Router.add {
  "" : 'home'
  "/:encoded_name" : (encoded_name) ->
    Session.set 'encoded_name', encoded_name
    if localStorage.getItem('player_id') isnt "undefined" and localStorage.getItem('player_id')
      newGoToSlide(encoded_name, Number(localStorage.getItem('last_slide')))
    else
      'new_player'
  "/:encoded_name/:slide_number" : (encoded_name, slide_number) ->
    newGoToSlide(encoded_name, slide_number)
}

newGoToSlide = (encoded_name, slide_number) ->
  localStorage.setItem('encoded_name', encoded_name)
  Session.set 'encoded_name', encoded_name
  localStorage.setItem 'last_slide', slide_number
  unless Session.equals('encoded_name', encoded_name)
    Meteor.Router.to "/#{encoded_name}/#{slide_number}"
    Session.set 'encoded_name', encoded_name
    'new_player'
  else
    Session.set 'current_slide', slide_number
    'slideshow'
