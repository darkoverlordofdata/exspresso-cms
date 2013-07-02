#+--------------------------------------------------------------------+
#| User.coffee
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
#	User Module
#


module.exports = class User extends system.core.Module

  #
  # property [String] name of this module
  #
  name: 'User'
  #
  # property [String] description of this module
  #
  description: ''
  #
  # property [String] path to this module
  #
  path: __dirname
  #
  # property [String] status of this module
  #
  active: true
  #
  # property [String] menu for this module
  #
  menu:
    Admin:
      uri: '/admin'
      tip: 'Login'

