Players = new Meteor.Collection("players")

#Meteor.startup ->
#  Meteor.autosubscribe ->
    #encoded_name = Session.get 'encoded_name'
    #   encoded_name = localStorage.getItem('encoded_name')
    #alert(encoded_name)
    #Meteor.subscribe("players", encoded_name) if encoded_name

Meteor.subscribe('players', 'devfest')

Template.new_player.events {
  'click #new_player': ->
    player_name = $("#player_name").val()
    encoded_name = Session.get 'encoded_name'
    room     = Rooms.findOne(encoded_name: encoded_name)
    room_cap = room.cap
    room_id  = room._id
    players_in_room = Players.find(room_id: room_id).fetch()
    id = Players.insert(
      name: player_name
      room_id: room_id
      host: (players_in_room.length is 0)
    )
    localStorage.setItem "player_id", id
    Session.set "player_id", id
    Meteor.Router.to "/#{encoded_name}/#{room.current_slide}"
  }

Meteor.startup ->
  # Use this for localStorage reactivity
  Session.set "player_id", localStorage.getItem("player_id")

Template.new_player.room_name = -> Session.get('encoded_name')
