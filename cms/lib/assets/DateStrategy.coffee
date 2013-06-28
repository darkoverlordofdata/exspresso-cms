#+--------------------------------------------------------------------+
#| assets/DateStrategy.coffee
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

module.exports = class cms.lib.assets.DateStrategy extends AbstractStrategy

  #
  # Etag
  #
  # Creates an etag based on file
  # last modifjed date.
  #
  # @param  [String]  filename
  # @return [Date]  caclculated etag
  #
  etag: ($filename) =>

    if @cache[$filename]?.etag?
      return @cache[$filename].etag

    $mdate = @lastModified($filename)
    $etag = Number($mdate.getTime()).toString(16)
    $stat = fs.statSync($filename)
    @updateCache $filename, $stat, $etag
    $etag

