module.exports =

  #|--------------------------------------------------------------------------
  #| Asset Driver Options
  #|--------------------------------------------------------------------------
  #|
  #| @see https://github.com/bminer/node-static-asset
  #|
  #|
  driver: 'static-asset'

  #|
  #|--------------------------------------------------------------------------
  #| Lifetime
  #|--------------------------------------------------------------------------
  #|
  #| the cache lifetime
  #|
  #|  lifetime: 31556900
  #|
  #|
  lifetime: 365*24*60*60*1000 # = 1 year

  #|
  #|--------------------------------------------------------------------------
  #|  Path
  #|--------------------------------------------------------------------------
  #|
  #|  The path to the static assets
  #|
  #|  path: path.join(APPPATH, 'public')
  #|
  path: APPPATH+"assets/"

  #|
  #|--------------------------------------------------------------------------
  #|  Strategy
  #|--------------------------------------------------------------------------
  #|
  #|   The strategy driver name
  #|
  #|
  strategy: 'hash' # 'date' | 'null'

  #|
  #|--------------------------------------------------------------------------
  #|  Algorithm
  #|--------------------------------------------------------------------------
  #|
  #|   Strategy specific
  #|
  #|
  algorithm: 'md5' # | 'sha1' ...

  #|
  #|--------------------------------------------------------------------------
  #|  Encoding
  #|--------------------------------------------------------------------------
  #|
  #|   Output string encoding
  #|
  #|
  encoding: 'hex' # | 'base64'

  #|
  #|--------------------------------------------------------------------------
  #|  Format
  #|--------------------------------------------------------------------------
  #|
  #|  How to format the resulting url
  #|
  #|  query     //host/path?v=etag
  #|  versions  //host/versions:etag/path
  #|
  format: 'versions' # @see https://github.com/3rd-Eden/versions

  #|
  #|--------------------------------------------------------------------------
  #|  Host
  #|--------------------------------------------------------------------------
  #|
  #|  Optional CDN
  #|
  host: 'd16acdn.aws.af.cm' # d16a versions server
