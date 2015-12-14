{CompositeDisposable} = require 'atom'
VideoModel =require './Models/VideoModel'
VideoView = require './Views/VideoView'
SearchView = require './Views/SearchView'
VideoViewModel = require './ViewModels/VideoViewModel'

module.exports = PlayyoutubeAtom =
  playyoutubeAtomView: null
  videoPanel: null
  searchpanel: null
  subscriptions: null

  activate: (state) ->
    @model = new VideoModel
    @view = new VideoView
    @menuview = new SearchView
    @view.getElement().classList.add('float-bottom-right')
    @viewModel = new VideoViewModel(@view.getElement(), @model)
    @videoPanel = atom.workspace.addBottomPanel(item:@viewModel.view, visible: false)
    @searchpanel = atom.workspace.addModalPanel(item:@menuview, visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'playyoutube-atom:toggle': => @toggle()

  deactivate: ->
    @videoPanel.destroy()
    @subscriptions.dispose()
    @playyoutubeAtomView.destroy()

  serialize: ->
    playyoutubeAtomViewState: @playyoutubeAtomView.serialize()

  toggle: ->
    if @videoPanel.isVisible()
      @videoPanel.hide()
    else
      @videoPanel.show()
    if @searchpanel.isVisible()
      @searchpanel.hide()
    else
      @searchpanel.show()
