#+--------------------------------------------------------------------+
#| index.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2012 - 2013
#+--------------------------------------------------------------------+
#|
#|
#+--------------------------------------------------------------------+
#
#
# Set the path constants and start exspresso
#
#

exspresso = require('exspresso')

exspresso.run
  APPPATH: 'cms'
  MODPATH: 'addins'
  DOCROOT: 'www'
