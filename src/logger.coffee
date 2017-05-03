bunyan = require 'bunyan'

module.exports = (app, config) ->
  root = bunyan.createLogger
    name: config.app
    stream: process.stderr
    level: config.log.verbosity
  global.logger = app.logger = app.locals.logger = root.child
    port: config.port
    app: config.app
    env: config.env
    component: config.comp
    version: app.locals.version
  app.logger.debug 'Application logger initialized.'
  (req, res, next) ->
    req.logger = res.locals.logger = app.logger.child
      request: req.id
      client: req.ip
    next()
