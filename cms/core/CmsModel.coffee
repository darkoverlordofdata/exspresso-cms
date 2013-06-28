#+--------------------------------------------------------------------+
#| CmsModel.coffee
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
#	Class CmsModel
#
module.exports = class cms.core.CmsModel extends system.core.Model

  source: null

  constructor: ($args...) ->
    super $args...

    @source = plural(@constructor.name.replace(/Model$/, '').toLowerCase())


    log_message 'debug', 'CmsModel Initialized %s', @source
