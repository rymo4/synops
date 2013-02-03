Slideshows = new Meteor.Collection('slideshows')
Slides = new Meteor.Collection('slides')

Meteor.autosubscribe ->
  # Don't have collections here
  Meteor.subscribe('slides', Session.get('encoded_name'))

Meteor.subscribe('slideshows')

Template.slideshow.current_slide = ->
  return undefined if Slideshows.find().fetch().length is 0
  room = Rooms.findOne encoded_name: Session.get('encoded_name')
  console.log room
  slideshow = Slideshows.findOne _id: room.slideshow_id
  Slides.findOne(
    slideshow_id: slideshow._id
    page: (Session.get('current_slide') || 1)
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

goToSlide = (name, slide_num) ->
    Router.goToSlide(name, slide_num)
    Session.set('current_slide', slide_num)
    Rooms.update {
      encoded_name: name
    }, {
      $set: {
        current_slide: slide_num
      }
    }

Template.slideshow.events
  'click #next_slide': ->
    name = Session.get 'encoded_name'
    next = Number(Session.get('current_slide')) + 1
    goToSlide(name, next)

  'click #previous_slide': ->
    name = Session.get 'encoded_name'
    previous = Number(Session.get('current_slide')) - 1
    goToSlide(name, previous)