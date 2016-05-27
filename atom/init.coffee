atom.commands.add 'atom-workspace', 'dot-atom:clean-mode', ->
  atom.commands.dispatch editorView, 'tree-view:show'
  atom.commands.dispatch editorView, 'tree-view:toggle'

  config.set 'editor.showLineNumbers', false
