Slideshows = new Meteor.Collection('slideshows')
Slides = new Meteor.Collection('slides')

Meteor.autosubscribe ->
  # Don't have collections here
  Meteor.subscribe('slides', Session.get('encoded_name'))

Meteor.subscribe('slideshows')

Template.slideshow.current_slide = ->
  return undefined if Slideshows.find().fetch().length is 0
  room = Rooms.findOne encoded_name: Session.get('encoded_name')
  slideshow = Slideshows.findOne _id: room.slideshow_id
  Slides.findOne(
    slideshow_id: slideshow._id
    page: Number(Session.get('current_slide') || 1)
  )

marked.setOptions(
  gfm: true
  tables: true
  breaks: true
  pedantic: false
  sanitize: false
  smartLists: true
)

Template.slideshow.current_player = ->
  Players.findOne _id: Session.get("player_id")

Template.people.people = ->
  name = Session.get 'encoded_name'
  room = Rooms.findOne encoded_name: name
  Players.find(room_id: room._id).fetch()

goToSlide = (name, slide_num) ->
  Meteor.Router.to "/#{name}/#{slide_num}"
  Session.set('current_slide', slide_num)
  Rooms.update {
    encoded_name: name
  }, {
    $set: {
      current_slide: slide_num
    }
  }

Template.slideshow.events
  'click #new_slide': ->
    encoded_name = Session.get 'encoded_name'
    room = Rooms.findOne encoded_name: encoded_name
    num_slides = Slides.find(slideshow_id: room.slideshow_id).fetch().length
    id = Slides.insert
      slideshow_id: room.slideshow_id
      page: num_slides + 1
      text: '# Change Me!' # Tie in for templates
    console.log id

  'click #next_slide': ->
    name = Session.get 'encoded_name'
    next = Number(Session.get('current_slide')) + 1
    goToSlide(name, next)

  'click #previous_slide': ->
    name = Session.get 'encoded_name'
    previous = Number(Session.get('current_slide')) - 1
    goToSlide(name, previous)
