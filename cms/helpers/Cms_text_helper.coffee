#+--------------------------------------------------------------------+
#  Cms_text_helper.coffee
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
# Application CmsText Helpers
#

#
# abstract
#
# side-bar navigation menu
#
# @param  [Object]  input html string
# @param  [String]  allowed tags to leave
# @return [String]  the cleaned string
#
exports.abstract = ($input) ->

  character_limiter(strip_tags($input.split('.', 3).join('.')+'.'), 140)



#  ------------------------------------------------------------------------
#
# Export helpers to the global namespace
#
#
for $name, $body of module.exports
  define $name, $body
