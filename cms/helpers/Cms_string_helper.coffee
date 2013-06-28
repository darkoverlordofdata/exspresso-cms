#+--------------------------------------------------------------------+
#  Cms_string_helper.coffee
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
# Application CmsString Helpers
#

#
# strp_tags
#
#
# @param  [Object]  input html string
# @param  [String]  allowed tags to leave
# @return [String]  the cleaned string
#
exports.strip_tags = ($input, $allowed) ->

  $allowed = ((($allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('')
  # making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
  $tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi
  $commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi
  $input.replace($commentsAndPhpTags, '').replace $tags, ($0, $1) ->
    if $allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 then $0 else ''

#  ------------------------------------------------------------------------
#
# Export helpers to the global namespace
#
#
for $name, $body of module.exports
  define $name, $body
