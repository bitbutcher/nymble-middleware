{ difference } = require 'lodash'
{ string } = require 'nymble-utils'

role = (roles...) -> (req, res, next) ->
  return next() if req.user.role in roles
  req?.logger?.warn "Client authenticated with an insufficient role '%s'.  A role of %s is required.",
    req.user.role, string.options_for roles...
  next status: 403

permission = (permissions...) -> (req, res, next) ->
  lacking = difference(permissions, req.user.permissions)
  return next() unless lacking.length
  req?.logger?.warn 'Client is authenticated, but lacks the %s permission(s).', string.criteria_for lacking...
  next status: 403

module.exports = { role, permission }
