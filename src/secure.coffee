module.exports = (app, config) ->
  app.enable 'trust proxy' if app.settings.env is 'production'
  (req, res, next) ->
    return next() unless config.secure and not req.secure
    req?.logger?.warn 'The client attempted to communicate via an insecure protocol.'
    res.set 'Strict-Transport-Security', 'max-age=31536000'
    if req.method is 'GET'
      res.redirect 301, "https://#{req.get 'HOST'}#{req.url}"
    else
      res.status(403).send 'Use HTTPS when communicating with this server.'
