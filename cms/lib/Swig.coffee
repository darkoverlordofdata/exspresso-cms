#+--------------------------------------------------------------------+
#| Swig.coffee
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

module.exports = class cms.lib.Swig

  _driver       : 'swig'
  _allowErrors  : false
  _autoescape   : false
  _cache        : false
  _encoding     : 'utf8'
  _filters      : {}
  _root         : APPPATH+'themes/wurdz/layout/'
  _tags         : {}
  _extensions   : {}
  _tzOffset     : 0
  _auto         : []

  #
  # property  [Object]  driver module
  #
  driver: null

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
  # Initialize
  #
  # @param [Object] config  the config/swig.coffee array
  # @returns none
  #
  initialize: ($config = {}) ->

    for $key, $val of @
      if $key is '_auto'
        $config.auto ?= []
        @_auto ?= []
        @_auto = [].concat(@_auto, $config.auto)

      else
        if $key[0] is '_'
          $config[$key[1..]] = $val unless $config[$key[1..]]?

    @driver = require(@_driver)
    @filters $config.filters
    @tags $config.tags
    @driver.init $config


  #
  # Render
  #
  # @param  [String]  tmpl the template
  # @param  [Object]  data  hash of variable to merge into template
  # @return [String] the rendered markup
  #
  render: ($tmpl, $data) ->
    (@driver.compile($tmpl))($data)


  #
  # Create custom filters
  #
  # @returns [Object]
  #
  filters: ($filters = {}) ->

    $filters['printf'] = require('util').format

    $filters

  #
  # Dynamically create custom tags
  # to wrap Exspresso view helpers
  #
  # @returns [Object]
  #
  tags: ($tags = {}) ->

    helpers = require("swig/lib/helpers")
    #
    # Bind each swig auto tag to an exspresso view helper
    #
    bind = ($parser, $helper) ->

      $output = ''
      for $arg, $index in @args
        $output+= helpers.setVar("_$#{$index}", $parser.parseVariable($arg))

      $output+= "_output += _context.#{$helper}.call(_context"
      for $index in [0...@args.length]
        $output+= ", _$#{$index}"
      $output+= ");"

    for $auto in @_auto
      do ($auto) ->
        $tags[$auto] = ($indent, $parser) ->
          return bind.call(@, $parser, $auto)

    $tags

