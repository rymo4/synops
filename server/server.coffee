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
    name: "devfest"
  Rooms.insert
    current_slide: 1
    encoded_name: "devfest"
    cap: 10000
    slideshow_id: id
    broadcasting: false
  Slides.insert
    slideshow_id: id
    page: 1
    text: """
      # Synops - Slideshows for Hackers
      
      ## syn·apse
      ### /ˈsinˌaps/, Noun
      > A junction between two nerve cells, consisting of a minute gap across which impulses pass by diffusion of a neurotransmitter.

      <img src="http://nehaagrawal.files.wordpress.com/2009/12/6_20synapse.jpg" width=300/>

      ## syn·op·sis
      ### /səˈnäpsis/, Noun
      > A brief summary or general survey of something.

    """
    shownotes: """
      Checkout the [code](https://github.com/rymo4/synops)!
      Built with: [Meteor](http://Meteor.com), [Foundation](http://foundation.zurb.com/), [EpicEditor](http://epiceditor.com/), and some other stuff
    """
  Slides.insert
    slideshow_id: id
    page: 2
    text: """
    # We Like CODE
    # (Not this)
    <img src="http://www.baycongroup.com/powerpoint/images/power_point_window.gif" width="80%"/>
    """
    shownotes: """
      Don't sue me, here is the [source](http://www.baycongroup.com) for the pic (I have no idea what that site is).
    """
  Slides.insert
    slideshow_id: id
    page: 3
    text: """
    # WAT
    ![WAT](http://jinkchak.files.wordpress.com/2012/10/jackie-chan-meme.jpg)
    """
    shownotes: "[source](http://jinkchak.files.wordpress.com/2012/10/jackie-chan-meme.jpg)"
  Slides.insert
    slideshow_id: id
    page: 4
    text: """
    # WAT
    ![WAT](http://jinkchak.files.wordpress.com/2012/10/jackie-chan-meme.jpg)
    # Write in [MARKDOWN](https://help.github.com/articles/github-flavored-markdown) instead
    ```
    # This is a header
    1. And here is
    2. a list
    ```
    """
    shownotes: "[source](http://jinkchak.files.wordpress.com/2012/10/jackie-chan-meme.jpg)"
  Slides.insert
    slideshow_id: id
    page: 5
    text: """
      # Run Arbitrary JavaScript on Your Slides
      <iframe style="width: 100%; height: 100%" src="http://jsfiddle.net/uzMPU/embedded/result/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>
      # Great for demos!
      """
    shownotes: """
      This is what happens when [Notch](http://en.wikipedia.org/wiki/Markus_Persson) makes a [JSFiddle](http://jsfiddle.net/).
    """
  Slides.insert
    slideshow_id: id
    page: 6
    text: """
      # Show Off Code

      Perl one liner to compute primes ([source](http://en.wikipedia.org/wiki/One-liner_program)):
      ```perl
        my $z = sub { grep { $a=$_; !grep { !($a % $_) } (2..$_-1)} (2..$_[0]) }
      ```

      Haskell version ([source](http://blog.fogus.me/2011/06/03/10-haskell-one-liners-to-impress-your-friends/)):
      ```haskell
        let pgen (p:xs) = p : pgen [x|x <- xs, x `mod` p > 0]
      ```
    """
    shownotes: "Yeah, this code is ugly."
  Slides.insert
    slideshow_id: id
    page: 7
    text: """
      # Edit in Realtme
      * Remove the lag between editing and practicing
      * Google Drive style collaboration
    """
    shownotes: "[Look how easy this is in Meteor](http://www.skalb.com/2012/04/16/creating-a-document-sharing-site-with-meteor-js/)"

