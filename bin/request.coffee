#!/usr/bin/env coffee
request = require 'request-promise'
request
  uri: process.argv[2]
  resolveWithFullResponse: true
.then (response)->
  process.stdout.write JSON.stringify response
