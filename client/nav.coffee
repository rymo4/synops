Template.nav.url = ->
  name = Session.get('encoded_name')
  "#{Meteor.absoluteUrl()}#{name}" if name

Template.nav.count = ->
  num = Players.find().fetch().length
  "Watchers: #{num}" unless num is 0
