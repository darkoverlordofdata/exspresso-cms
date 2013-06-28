#+--------------------------------------------------------------------+
#| assets/AbstractStrategy.coffee
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

module.exports = class cms.lib.assets.AbstractStrategy

  fs = require('fs')
  url = require('url')
  path = require('path')

  #
  # @property [Object]  cache for asset properties
  #
  cache: {}
  #
  # @property [Boolean] is cache in use?
  #
  cacheOn: if ENVIRONMENT is "production" then true else false
  #
  # @property [String] cdn host name
  #
  host: ''
  #
  # @property [String] how to format the etag in the asset url
  #
  format: ''
  #
  # @property [String] show etag as hex or base36
  #
  encoding: ''
  #
  # @property [Number] asset cache lifetime in msec
  #
  lifetime: 0
  #
  # @property [String] strategy to use when creating the etag
  #
  strategy: ''
  #
  # @property [String] specific algorithm used by a strategy
  #
  algorithm: ''

  constructor: ($config = {}) ->

    @host = $config.host
    @format = $config.format
    @encoding = $config.encoding
    @lifetime = $config.lifetime
    @strategy = $config.strategy
    @algorithm = $config.algorithm

  #
  # Add To Cache
  #
  # @param  [String]  filename
  # @param  [Oject] stat
  #
  updateCache: ($filename, $stat, $etag) =>

    if @cacheOn
      $cache = @cache[$filename]
      if not $cache?
        $cache = @cache[$filename] = {}
      $cache.mtime = $stat.mtime || $cache.mtime
      $cache.size = $stat.size || $cache.size
      $cache.etag = $etag || $cache.etag

  #
  # Last Modified
  #
  # @param  [String]  filename
  # @return [Date]  Time last modified
  #
  lastModified: ($filename) =>

    if @cache[$filename]?.lastModified?
      return @cache[$filename].lastModified

    $stat = fs.statSync($filename)
    @updateCache $filename, $stat
    $stat.mtime

  #
  # Etag
  #
  # @param  [String]  filename
  # @return [Date]  caclculated etag
  #
  etag: ($filename) =>
    undefined

  #
  # Expires
  #
  # @param  [String]  filename
  # @return [Date]  when the asset will expire
  #
  expires: ($filename) =>

    $d = new Date()
    $d.setTime $d.getTime() + @lifetime
    $d

  #
  # File Fingerprint
  #
  # @param  [String]  filename
  # @param  [String]  fullpath
  # @return [String]  the mangled url
  #
  fileFingerprint:($filename, $fullPath) =>

    switch @format

      when 'versions' then "versions:#{@etag($fullPath)}/#{$filename}"
      when 'query'    then "#{$filename}?v=#{@etag($fullPath)}"

      else $filename

