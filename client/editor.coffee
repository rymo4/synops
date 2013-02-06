editor_opts =
  container: 'epiceditor'
  basePath: "/epiceditor"
  clientSideStorage: true
  localStorageName: 'epiceditor'
  useNativeFullsreen: true
  parser: marked
  file:
    name: 'epiceditor'
    defaultContent: ''
    autoSave: false
  focusOnLoad: false
  shortcut:
    modifier: 18
    fullscreen: 70
    preview: 80

Template.slideshow.rendered = ->
  editor = new EpicEditor(editor_opts).load()
  filename = "slide-#{Session.get('current_slide')}"
  editor.remove(filename)
  editor.importFile(filename, Template.slideshow.current_slide().text)
  editor.open filename
  editor.removeListener 'edit'
  editor.on 'save', ->
    markdown = this.getElement('editor').body.innerHTML.replace(/<br>/g, '\n').replace(/<\/?div>/g, '')
    console.log markdown
    #.replace(/<br>/g, '\n')
    room = Rooms.findOne encoded_name: Session.get('encoded_name')
    slideshow_id = room.slideshow_id
    slide_selector =
      slideshow_id: slideshow_id
      page: Number(Session.get('current_slide'))
    slide = Slides.findOne slide_selector
    window.editor = editor
    if slide.text isnt markdown
      Slides.update slide_selector,
        $set:
          text: markdown
  editor.preview()
  unless Players.findOne(_id: Session.get('player_id')).host
    editor.iframe.getElementById('epiceditor-utilbar').innerHTML = ''
