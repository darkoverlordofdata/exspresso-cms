#+--------------------------------------------------------------------+
#| assets/NullStrategy.coffee
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

module.exports = class cms.lib.assets.NullStrategy extends AbstractStrategy


  #
  # Etag
  #
  # @param  [String]  filename
  # @return [Date]  caclculated etag
  #
  etag: ($filename) =>
    ''

  #
  # File Fingerprint
  #
  # @param  [String]  filename
  # @param  [String]  fullpath
  # @return [String]  the mangled url
  #
  fileFingerprint:($filename, $fullPath) =>
    $filename
