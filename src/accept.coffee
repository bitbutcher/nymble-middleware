{ string } = require 'nymble-utils'

module.exports = (types...) -> (req, res, next) ->
  return next() if req.accepts types
  options = string.options_for types...
  req?.logger?.warn "The client sent an incompatible 'Accept' header of %s.  The client must accept content of type %s.",
    req.get('Accept'), options
  res.status(406).json global: errors: [ "The client must accept content of type #{options}." ]
