auth = require 'basic-auth'

basic = (realm, delegate, failure = (req, res, next) -> next status: 404) -> (req, res, next) ->
  fail = ->
    req.logger.warn "Basic authentication failed for realm '%s'.", realm
    res.set 'WWW-Authenticate': "Basic realm=\"#{realm}\""
    failure req, res, next
  creds = auth req
  return fail() unless creds?
  delegate creds.name, creds.pass, req, res, next, fail

module.exports = { basic }
