#+--------------------------------------------------------------------+
#| assets/HashStrategy.coffee
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

AbstractStrategy = load_class(APPPATH+'lib/assets/AbstractStrategy.coffee')

module.exports = class cms.lib.assets.HashStrategy extends AbstractStrategy

  fs = require('fs')
  crypto = require('crypto')

  #
  # Etag
  #
  # Creates an etag based on hash
  # of file contents.
  #
  # @param  [String]  filename
  # @return [Date]  caclculated etag
  #
  etag: ($filename) =>

    if @cache[$filename]?.etag?
      return @cache[$filename].etag

    $data = fs.readFileSync($filename)
    $stat = fs.statSync($filename)
    $etag = crypto.createHash(@algorithm).update($data).digest(@encoding)
    @updateCache $filename, $stat, $etag
    $etag
