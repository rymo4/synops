Rooms = new Meteor.Collection("rooms")
Meteor.subscribe "rooms", ->
  name = Session.get('encoded_name')
  if name
    Router.setRoom name

Rooms.find().observe changed: (new_room, atIndex, old_room) ->
  if new_room.encoded_name is Session.get("encoded_name") 
    if new_room.broadcasting isnt old_room.broadcasting and new_room.broadcasting
      unless current_slide is new_room.current_slide or Players.findOne(_id: Session.get('player_id')).host
        Router.startGame new_room.encoded_name
    if new_room.current_slide isnt old_room.current_slide
      current_slide = Number(Session.get('current_slide') || 1)
      unless current_slide is new_room.current_slide or Players.findOne(_id: Session.get('player_id')).host
        Router.goToSlide(new_room.encoded_name, Number(new_room.current_slide))

Template.new_room.events
  "click #new_room": ->
    room_name = $("#room_name").val()
    encoded_name = helpers.urlEncode(room_name)
    room_cap = Number($("#room_cap").val())
    id = Slideshows.insert
      name: room_name
    Rooms.insert
      encoded_name: encoded_name
      cap: room_cap
      slideshow_id: id
    Session.set('encoded_name', encoded_name)
    Router.setRoom encoded_name

Template.in_room.events "click #start_game": ->
  start = confirm("Are you sure you want to start the game? " + "Nobody will be able to join after the game starts.")
  if start
    room = Rooms.findOne encoded_name: Session.get('encoded_name')
    Router.startGame room.encoded_name
    console.log "GAME STARTED"

Template.home.join_room = ->
  !Session.get('player_id')

Template.in_room.current_player = ->
  Players.findOne _id: Session.get("player_id")

Template.home.current_room = ->
  Rooms.findOne encoded_name: Session.get('encoded_name')

Template.nav.current_room = ->
  Rooms.findOne encoded_name: Session.get('encoded_name')

Template.in_room.current_room = ->
  Rooms.findOne encoded_name: Session.get('encoded_name')

Template.in_room.players = ->
  Players.find({}).fetch()

Template.in_room.other_players = ->
  Players.find _id:
    $ne: Session.get("player_id")

Meteor.startup ->
  # Use this for localStorage reactivity
  encoded_name = localStorage.getItem 'encoded_name'
  if encoded_name and encoded_name isnt "undefined"
    console.log 'STARTUP ' + encoded_name
    Session.set "encoded_name", encoded_name
