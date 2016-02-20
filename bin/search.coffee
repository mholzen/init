cat ~/data/search

query=process.argv[1]


find = require('find')
executable = (query, callback)->
  dirs = process.env.PATH.split ':'
  dirs.forEach (dir)->
    find.file , (files) ->
      callback files
