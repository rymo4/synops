Meteor.Router.add {
  "" : 'home'
  "/:encoded_name" : (encoded_name) ->
    Session.set 'encoded_name', encoded_name
    'new_player'
  "/:encoded_name/:slide_number" : (encoded_name, slide_number) ->
    unless Session.equals 'encoded_name', encoded_name
      Session.set 'encoded_name', encoded_name
      'new_player'
    else
      Session.set 'encoded_name', encoded_name
      Session.set 'current_slide', slide_number
      'slideshow'
}
