#+--------------------------------------------------------------------+
#  CmsRender.coffee
#+--------------------------------------------------------------------+
#  Copyright DarkOverlordOfData (c) 2012 - 2013
#+--------------------------------------------------------------------+
#
#  This file is a part of Exspresso
#
#  Exspresso is free software you can copy, modify, and distribute
#  it under the terms of the MIT License
#
#+--------------------------------------------------------------------+

#
# Exspresso Render Class
#
# This extension adds swig support
#
#
module.exports = class cms.core.CmsRender extends system.core.Render

  #
  # The swig template engine
  #
  # @param  [system.core.Exspresso] controller  Exspresso controller
  # @returns none
  #
  constructor: ($controller) ->

    super $controller
    log_message 'debug', 'CmsRender Initialized'

    load_class APPPATH+'lib/Swig.coffee'
    @swig = new cms.lib.Swig($controller, $controller.config.load('swig', true))


  #
  # Initialize
  #
  # @param  [Array] tags  list of auto tags
  # @returns none
  #
  initialize: ($tags) ->
    @swig.initialize auto: $tags

  #
  # Templates - *.tmpl
  #
  # Use django style swig templates
  #
  # @param  [String]  view the template
  # @param  [Object]  data  hash of variable to merge into template
  # @return [String] the rendered markup
  #
  tmpl: ($view, $data) ->
    @swig.render($view, $data)

