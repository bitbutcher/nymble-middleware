{ string } = require 'nymble-utils'

module.exports = (types...) -> (req, res, next) ->
  for type in types
    return next() if req.is type
  options = string.options_for types...
  req?.logger?.warn "The client sent an incompatible 'Content-Type' header of %s.  The client must send content of type %s.",
    req.get('Content-Type'), options
  res.status(415).json global: errors: [ "The client must send content of type #{options}." ]
