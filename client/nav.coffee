Template.nav.url = -> Meteor.absoluteUrl() + Session.get('encoded_name')
