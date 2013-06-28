#+--------------------------------------------------------------------+
#| theme.coffee
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
#	  Wurdz Theme Manifest
#
#
#

exports.id =            'wurdz'
exports.name =          'Exspresso Wurdz Theme'
exports.author =        'darkoverlordofdata'
exports.website =       'http://darkoverlordofdata.com'
exports.version =       '1.0'
exports.description =   'Exspresso Wurdz Theme'
exports.location =      APPPATH+'themes/'
exports.type =          'swig'

exports.regions =
  header          : 'Header'
  navigation      : 'Navigation bar'
  content         : 'Content'
  sidebar         : 'Sidebar'
  footer          : 'Footer'
  bottom          : 'Page bottom'
  analytics       : 'Google Analytics'


#
# Menu
#
# Defines the main page menu
#
exports.menu =
  Blog    :
    uri   : '/blog'
    tip   : 'Blog'
  Katra  :
    uri   : '/katra'
    tip   : 'Live Long And Prosper'
  Admin   :
    uri   : '/admin'
    tip   : 'Login'



#
# Scripts
#
# The script blocks available to this template
#
exports.script =

  ckeditor: '//d16acdn.aws.af.cm/ckeditor/ckeditor.js'
  coffeescript: '//cdnjs.cloudflare.com/ajax/libs/coffee-script/1.6.2/coffee-script.min.js'
  prettify: [
    '//google-code-prettify.googlecode.com/svn/loader/run_prettify.js'
    """
    $(function() {
      prettyPrint();
    });
    """
  ]

#
# CSS
#
# The style sheets available to this template
#
exports.css =

  signin: '//d16acdn.aws.af.cm/css/signin.min.css'
  sidenav: '//d16acdn.aws.af.cm/css/sidenav.min.css'
  prettify:  [
    '//google-code-prettify.googlecode.com/svn/loader/prettify.css'
    """
    code {font-size: 100%};
    """
  ]


