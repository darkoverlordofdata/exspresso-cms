#+--------------------------------------------------------------------+
#  Cms_date_helper.coffee
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
# Application Cms Date Helpers
#

$short_months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
]

exports.date_to_monddyyyy = ($date = $Date.now()) ->
  $short_months[$date.getMonth()]+' '+$date.getDate()+', '+$date.getFullYear()

#  ------------------------------------------------------------------------
#
# Export helpers to the global namespace
#
#
for $name, $body of module.exports
  define $name, $body
