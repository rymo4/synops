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

Template.slide_controls.current_player = ->
  Players.findOne _id: Session.get("player_id")

Template.slide_list.slides = ->
  _.map Slides.find({}, sort: {page: 1}).fetch(), (slide) ->
    _.defaults slide,
      preview: slide.text.substring(0, 20) + '...'
      callout: if (slide.page == Number(Session.get('current_slide'))) then 'callout' else ''

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

Template.slide_list.presentation_mode_on = -> Session.get('presentation_mode')
Template.slideshow.presentation_mode_on = -> Session.get('presentation_mode')

Template.slide_list.events
  'click .slide_preview': (e) ->
    num = Number $(e.target).attr('data-slide-num')
    goToSlide(Session.get('encoded_name'), num)

Template.slide_list.events
  'click #new_slide': ->
    encoded_name = Session.get 'encoded_name'
    room = Rooms.findOne encoded_name: encoded_name
    num_slides = Slides.find(slideshow_id: room.slideshow_id).fetch().length
    Slides.insert
      slideshow_id: room.slideshow_id
      page: num_slides + 1
      text: '# Change Me!' # Tie in for templates
    goToSlide(encoded_name, num_slides + 1)

Template.slideshow.watchers = -> Players.find()

Template.slide_controls.events
  'click #presentation_mode': ->
    mode_on = Session.get 'presentation_mode'
    Session.set('presentation_mode', !mode_on)
  'click #next_slide': ->
    name = Session.get 'encoded_name'
    next = Number(Session.get('current_slide')) + 1
    goToSlide(name, next)

  'click #previous_slide': ->
    name = Session.get 'encoded_name'
    previous = Number(Session.get('current_slide')) - 1
    goToSlide(name, previous)
