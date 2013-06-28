#+--------------------------------------------------------------------+
#| CmsConnect.coffee
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

#
#	CmsConnect driver
#
#   An adapter to the connect server instance
#
#   This extension adds static asset caching
#
module.exports = class cms.core.CmsConnect extends system.core.Connect

  #
  # @property [String] http driver: express
  #
  driver: 'express' # Override the default value 'connect',
                    # express is required for 'static-assets' cacheing.

  assets: null

  constructor: ($controller) ->

    log_message 'debug', 'CmsConnect Initialized'
    load_class APPPATH+'lib/Assets.coffee'
    @assets = new cms.lib.Assets($controller, $controller.config.load('assets', true))
    super $controller

  #
  # Initialize the assets
  #
  #   First - set up static cacheing
  #
  # @param  [Object]  driver  the instantiated express driver
  # @return [Void]
  #
  initialize_assets:($driver, $render) =>

    @assets.initialize @, $render
    super $driver, $render

