Players    = new Meteor.Collection("players")
Rooms      = new Meteor.Collection("rooms")
Slideshows = new Meteor.Collection('slideshows')
Slides     = new Meteor.Collection('slides')

Meteor.publish 'slides', (encoded_name) ->
  room = Rooms.findOne encoded_name: encoded_name
  slideshow = Slideshows.findOne _id: room.slideshow_id
  Slides.find slideshow_id: slideshow._id

Meteor.publish 'slideshows', -> Slideshows.find()

Meteor.publish "rooms", -> Rooms.find()

Meteor.publish "players", (encoded_name) ->
  room_id = Rooms.findOne(encoded_name: encoded_name)._id
  Players.find room_id: room_id

Meteor.startup ->
  Slides.remove({})
  Slideshows.remove({})
  Players.remove({})
  Rooms.remove({})
  id = Slideshows.insert
    name: "test"
    current_page: 1
  Rooms.insert
    encoded_name: "test"
    cap: 10000
    slideshow_id: id
    broadcasting: false
  Slides.insert
    slideshow_id: id
    page: 1
    text: "# Title Goes here\n\nThis is a paragraph.\n\n`this is code`"
  Slides.insert
    slideshow_id: id
    page: 2
    text: "# Other Title Goes here\n\n* List item one.\n* Item two."
  Slides.insert
    slideshow_id: id
    page: 3
    text: """
      ```ruby
      require 'redcarpet'
      markdown = Redcarpet.new("Hello World!")
      puts markdown.to_html
      ```
      """

