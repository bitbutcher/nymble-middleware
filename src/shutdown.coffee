{ parallel } = require 'async'
{ delay } = require 'nymble-utils'

SECONDS = 1000

module.exports = (app, setting='graceful shutdown') ->
  listen = app.listen
  app.listen = ->
    server = listen.apply app, arguments
    closers = []
    shutdown = ->
      process.once 'SIGINT', ->
        app.logger.warn 'Graceful shutdown canceled. Forcefully shutting down.'
        process.exit 1
      app.logger.info 'Received shutdown signal. Attempting graceful shutdown...'
      app.enable setting
      server.close ->
        parallel closers, ->
          app.logger.info 'Graceful shutdown complete.'
          process.exit 0
      delay 180 * SECONDS, ->
        app.logger.error 'Unable to gracefully shutdown within the alotted time.  Forcefully shutting down.'
        process.exit 1
    process.once 'SIGTERM', shutdown
    process.once 'SIGINT', shutdown
    server.closer = (closer) ->
      closers.push closer
    server
  (req, res, next) ->
    return next() unless app.enabled setting
    req.logger.warn 'Rejecting connection due to graceful shutdown.'
    res.set 'Connection': 'close'
    res.sendStatus 502
