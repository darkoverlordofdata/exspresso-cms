#+--------------------------------------------------------------------+
#| index.coffee
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
#
# Set the path constants and start exspresso
#
#

module.exports =

  #
  # Run Exspresso
  #
  # Set the MODPATH and DOCPATH globals and boot exspresso.
  #
  # @param [Object] config  sets the expresso paths
  # @return none
  #
  run: ($config = {}) ->

    $config['APPPATH'] = "#{__dirname}/cms"
    $config['MODPATH'] = "#{__dirname}/plugins" unless $config['MODPATH']?

    require('exspresso').run $config
