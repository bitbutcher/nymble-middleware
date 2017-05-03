keygen = require 'keygen'

module.exports = (header = 'X-Request-Id') -> (req, res, next) ->
  req.id = req.get(header) or keygen.url keygen.small
  res.set header, req.id
  next()
