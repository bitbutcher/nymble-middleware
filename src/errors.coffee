{ omit, pick } = require 'lodash'
httpError = require 'http-errors'

module.exports = (report) -> (err, req, res, next) ->
  error = httpError err.status, omit err, 'status'
  logger = req.logger ? req.app.logger
  logger?.error pick(err, 'status', 'stack'), err if error.status / 100 is 5
  report error, req, res, next
