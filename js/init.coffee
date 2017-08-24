#!/usr/bin/env coffee
request = require 'request-promise'
highland = require 'highland'

global.get = (uri)->
  request
    uri: uri
    resolveWithFullResponse: true

global.words = ->
  highland(process.stdin)
  .split()
  .filter (x) -> x.length > 0
