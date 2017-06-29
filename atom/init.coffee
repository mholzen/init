atom.commands.add 'atom-workspace', 'dot-atom:clean-mode', ->
  atom.commands.dispatch editorView, 'tree-view:show'
  atom.commands.dispatch editorView, 'tree-view:toggle'

  config.set 'editor.showLineNumbers', false

  # spell check off

atom.commands.add 'atom-workspace', 'fold:toggle', ->
  editor = atom.workspace.getActiveTextEditor()
  position = editor.getCursorBufferPosition()
  if editor.isFoldedAtBufferRow(position.row)
    editor.unfoldBufferRow(position.row)
  else
    editor.foldBufferRow(position.row)
