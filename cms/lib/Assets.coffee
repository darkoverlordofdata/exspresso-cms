#+--------------------------------------------------------------------+
#| Assets.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2012 - 2013
#+--------------------------------------------------------------------+
#|
#| This file is a part of Exspresso
#|
#| Exspresso is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+

module.exports = class cms.lib.Assets

  _driver       : 'static-asset'
  _host         : ''
  _path         : ''
  _format       : ''
  _encoding     : ''
  _lifetime     : 0
  _strategy     : ''
  _algorithm    : ''
  #
  # constructor
  #
  # @param  [Object]  controller
  # @param  [Object]  config  configuration array
  #
  constructor: ($controller, $config = {}) ->

    @controller = $controller
    for $key, $val of $config
      @["_#{$key}"] = $val
    log_message 'debug', "Assets Class Initialized"

  #
  # Initialize asset cacheing
  #
  # @param  [system.core.Connect]  server the http adapter
  # @param  [system.core.Render]  render the rendering factory
  # @param  [Object]  config  optional configuration overrides
  #
  initialize: ($server, $render, $config = {}) ->

    for $key, $val of @
      if $key[0] is '_'
        $config[$key[1..]] = $val unless $config[$key[1..]]?

    $driver = require(@_driver)
    $strategy = ucfirst(@_strategy)
    Strategy = load_class(APPPATH+"lib/assets/#{$strategy}Strategy.coffee")
    $server.app.use $driver(@_path, new Strategy($config))
    $render.initialize ['css', 'script']
    $this = @


    #
    # Add View Helpers
    #
    $server.setHelpers

      css: ($assetUrl, $prodAssetUrl) ->
        @link_tag($this.prepare_asset(@req, $assetUrl, $prodAssetUrl))

      script: ($assetUrl, $prodAssetUrl) ->
        @javascript_tag($this.prepare_asset(@req, $assetUrl, $prodAssetUrl))

  #
  # Prepare an asset
  #
  # Prepare local assets for use as cdn origin
  #
  # @access private
  # @param  [String]  url asset url
  # @param  [String]  url production asset url (optional)
  # @return [String]  the html
  #
  prepare_asset: ($req, $assetUrl, $prodAssetUrl = $assetUrl) ->

    $url = if ENVIRONMENT is 'production' then $prodAssetUrl else $assetUrl

    return $url if /^https?:\/\//.test($url)  # a protocal?
    return $url if /^\/\/\w+\./.test($url)    # a cdn?

    if @_host?
      "//#{@_host}/#{$req.assetFingerprint($url)}"
    else
      $req.assetFingerprint($url)

