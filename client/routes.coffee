RoomRouter = Backbone.Router.extend(
  routes:
    ":encoded_name": "setRoom"
    "logout": "logout"
    ":encoded_name/:slide_number": "goToSlide"
    "": "home"

  goToSlide: (encoded_name, slide_number) ->
    Router.startGame(encoded_name)
    unless Session.get('player_id')
      Session.set 'join_room', true
    Session.set('current_slide', Number(slide_number))
    @navigate encoded_name + '/' + slide_number

  startGame: (encoded_name) ->
    Rooms.update
      encoded_name: encoded_name
    ,
      $set:
        broadcasting: true
    num = Number(Session.get('current_slide') || 1)
    Session.set('current_slide', num)
    @navigate "#{encoded_name}/#{num}"

  logout: ->
    Players.remove _id: localStorage.getItem("player_id")
    Session.set "player_id", null
    localStorage.setItem "player_id", null
    @navigate "", true

  home: ->
    Session.set "room_id", undefined
    localStorage.removeItem "room_id"
    localStorage.removeItem "encoded_name"
    Session.set "encoded_name", undefined

  setRoom: (encoded_name) ->
    localStorage.setItem "encoded_name", encoded_name
    Session.set "encoded_name", encoded_name
    room = Rooms.findOne encoded_name: encoded_name
    if room.broadcasting
      alert()
      Router.goToSlide(encoded_name, Number(room.current_page || 1))
    @navigate encoded_name
)

Router = new RoomRouter

helpers = urlEncode: (name) ->
  name.replace(/^ /, "").replace(RegExp(" $"), "").replace RegExp(" ", "g"), "-"

Backbone.history.start({pushState: true})
