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
    autoSave: 100
  focusOnLoad: false
  shortcut:
    modifier: 18
    fullscreen: 70
    preview: 80

Template.slideshow.rendered = ->
  @editor = new EpicEditor(editor_opts).load()
  filename = "slide-#{Session.get('current_slide')}"
  @editor.remove(filename)
  @editor.importFile(filename, Template.slideshow.current_slide().text)
  @editor.open filename
  @editor.preview()

