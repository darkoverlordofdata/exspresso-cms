module.exports =

  #|
  #|--------------------------------------------------------------------------
  #| Swig Options
  #|--------------------------------------------------------------------------
  #|
  #| @see https://github.com/paularmstrong/swig
  #|
  #|
  allowErrors: false
  autoescape: false
  cache: false
  encoding: 'utf8'
  filters: {}
  root: APPPATH+'themes/wurdz/layout/'
  tags: {}
  extensions: {}
  tzOffset: 0

  #|
  #|--------------------------------------------------------------------------
  #| Auto Custom Tags
  #|--------------------------------------------------------------------------
  #|
  #| Auto tags created for the following helpers
  #|
  #|
  auto: [
    # url_helper
    'site_url'
    'base_url'
    'current_url'
    'uri_string'
    'index_page'
    'anchor'
    'anchor_popup'
    'mailto'
    'safe_mailto'
    'auto_link'
    'url_title'
    # form_helper
    'form_open'
    'form_open_multipart'
    'form_hidden'
    'form_input'
    'form_password'
    'form_upload'
    'form_textarea'
    'form_multiselect'
    'form_dropdown'
    'form_checkbox'
    'form_radiobutton'
    'form_submit'
    'form_reset'
    'form_button'
    'form_label'
    'form_fieldset'
    'form_close'
    'forn_error'
    'validation_errors'
    # text helper
    'ellipsize'
    'abstract'
    # html helper
    'paginate'
  ]

