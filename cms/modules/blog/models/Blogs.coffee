#+--------------------------------------------------------------------+
#| Blogs.coffee
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
#	Blog Data Model
#
module.exports = class cms.modules.blog.models.Blogs extends system.core.Model

  _categories_load  = false # skip 1st instantiation
  _categories       : null  # category table cache
  _category_names   : null  # hash of category names for drop-down list

  #
  # Initialize Blog Model
  #
  constructor: ($args...) ->

    super $args...

    defineProperties @,
      _categories       : {writeable: false, value: []}
      _category_names   : {writeable: false, value: {}}

    if _categories_load then @queue @_load_categories
    _categories_load = true


  #
  # Get all
  #
  # @param  [Function] $next  async function
  # @return [Void]
  #
  getAll: ($next) ->
    @db.select 'blogs.id, users.name AS author, categories.name AS category'
    @db.select 'blogs.status, blogs.created_on, blogs.updated_on, blogs.title'
    @db.select 'blogs.tags, blogs.body'
    @db.from 'blogs'
    @db.join 'users', 'users.uid = blogs.author_id', 'inner'
    @db.join 'categories', 'categories.id = blogs.category_id', 'inner'
    @db.get ($err, $blogs) ->
      return $next($err) if $err?
      $next null, $blogs.result()

  #
  # Get blogs by id
  #
  # @param  [Integer] $id blogs id
  # @param  [Function] $next  async function
  # @return [Void]
  #
  getById: ($id, $next) ->
    @db.from 'blogs'
    @db.where 'id', $id
    @db.get ($err, $blogs) ->
      return $next($err) if $err?
      $next null, $blogs.row()

  #
  # Get the most recently updated article
  #
  # @return [Void]
  #
  getLatest: ($next) ->
    @db.from 'blogs'
    @db.orderBy 'updated_on', 'desc'
    @db.limit 1
    @db.get ($err, $blogs) ->
      return $next($err) if $err?
      $next null, $blogs.row()

  #
  # Delete blogs by id
  #
  # @param  [Integer] $id blogs id
  # @param  [Function] $next  async function
  # @return [Void]
  #
  deleteById: ($id, $next) ->
    @db.where 'id', $id
    @db.delete 'blogs', $next

  #
  # Create new blogs doc
  #
  # @param  [Integer] $doc blogs document
  # @param  [Function] $next  async function
  # @return [Void]
  #
  create: ($doc, $next) ->

    @db.insert 'blogs', $doc, ($err) =>
      return $next($err) if $err?

      @db.insertId ($err, $id) ->
        return $next($err) if $err?
        $next null, $id

  #
  # Save blogs doc by id
  #
  # @param  [Integer] $id blogs id
  # @param  [Integer] $doc blogs document
  # @param  [Function] $next  async function
  # @return [Void]
  #
  save: ($id, $doc, $next) ->
    @db.where 'id', $id
    @db.update 'blogs', $doc, $next


  #
  # New Category
  #
  # Create a new category, update cache
  #
  # @param  [String]  $name new category name
  # @param  [Fundtion]  $next async callback
  # @return [Void]
  #
  newCategory: ($name, $next) ->

    @db.insert 'categories', name: $name, ($err) =>
      return $next($err) if $err?

      @db.insertId ($err, $id) =>
        return $next($err) if $err?

        @_categories.push id: $id, name: $name
        @_category_names[$name] = $name

        $next null, $id


  getCategories: () ->
    @_categories

  #
  # Category Names
  #
  # @return [Object] hash of category names for dropdown list
  #
  getCategoryNames: () ->
    @_category_names

  #
  # Category Name
  #
  # @param  [String]  id  category id
  # @return [String] the name associated with the id
  #
  getCategoryName: ($id) ->
    for $row in @_categories
      return $row.name if $id is $row.id
    ''

  #
  # Category Id
  #
  # @param  [String]  name  category name
  # @return [String] the id associated with the name
  #
  getCategoryId: ($name) ->
    for $row in @_categories
      return $row.id if $name is $row.name
    ''

  #
  # Load the Categories.
  #
  # 1. load the category table rows
  # 2. compile a drop down list of category names
  #
  # Save/Get values from cache
  #
  # @param  [Function]  next  async callback
  # @return [Void]
  #
  _load_categories: ($next) =>

    @db.from 'categories'
    @db.get ($err, $cat) =>
      return $next() if $err

      for $row in $cat.result()
        @_categories.push $row
        @_category_names[$row.name] = $row.name

      $data =
        categories: @_categories
        category_names: @_category_names

      $next()

#    @cache.get 'blogs._load_categories', ($err, $data) =>
#
#      if $data isnt false and $data isnt null
#        @_categories = $data.categories
#        @_category_names = $data.category_names
#        return $next(null)
#
#      @db.from 'categories'
#      @db.get ($err, $cat) =>
#        return $next() if $err
#
#        for $row in $cat.result()
#          @_categories.push $row
#          @_category_names[$row.name] = $row.name
#
#        $data =
#          categories: @_categories
#          category_names: @_category_names
#
#        @cache.save 'blogs._load_categories', $data, -1, $next

  #
  # Install the Blog Module data
  #
  # @return [Void]
  #
  install: () ->

    @load.dbforge() unless @dbforge?
    @queue @install_categories
    @queue @install_blogs
    @queue @install_tags
    @queue @install_blog_tags



  install_tags: ($next) =>

    @dbforge.createTable 'tags', $next, ($table) ->
      $table.addKey 'id', true
      $table.addField
        id:
          type: 'INT', constraint: 5, unsigned: true, auto_increment: true
        name:
          type: 'VARCHAR', constraint: 255


  install_blog_tags: ($next) =>

    @dbforge.createTable 'blog_tags', $next, ($table) ->
      $table.addKey 'id', true
      $table.addField
        id:
          type:'INT', constraint:10, 'unsigned':true, null:false, auto_increment:true
        bid:
          type:'INT', constraint:10, 'unsigned':true, null:false
        tid:
          type:'INT', constraint:10, 'unsigned':true, null:false


  #
  # Step 1:
  # Install Check
  # Create the category table
  #
  # @param  [Function]  next  async callback
  # @return [Void]
  #
  install_categories: ($next) =>

    #
    # if categories doesn't exist, create and load initial data
    #
    @dbforge.createTable 'categories', $next, ($table) ->
      $table.addKey 'id', true
      $table.addField
        id:
          type: 'INT', constraint: 5, unsigned: true, auto_increment: true
        name:
          type: 'VARCHAR', constraint: 255

      $table.addData id: 1, name: "Article"


  #
  # Step 2:
  # Install Check
  # Create the blogs table
  #
  # @param  [Function]  next  async callback
  # @return [Void]
  #
  install_blogs: ($next) =>

    fs = require('fs')
    #
    # if blogs table doesn't exist, create and load initial data
    #
    @dbforge.createTable 'blogs', $next, ($table) ->
      $table.addKey 'id', true
      $table.addField
        id:
          type: 'INT', constraint: 5, unsigned: true, auto_increment: true
        author_id:
          type: 'INT'
        category_id:
          type: 'INT'
        status:
          type: 'INT'
        created_on:
          type: 'DATETIME'
        updated_on:
          type: 'DATETIME'
        updated_by:
          type: 'INT'
        title:
          type: 'VARCHAR', constraint: 255
        tags:
          type: 'TEXT'
        body:
          type: 'TEXT'


      $table.addData
        id: 1
        author_id: 2
        category_id: 1
        status: 1
        created_on: '2012-03-13 09:22:20'
        updated_on: '2013-03-13 09:22:20'
        updated_by: 2
        title: 'Katra'
        tags: ''
        body: """
              <p>
              <span style="font-size:28px;">Katra </span>is a basic language interpreter written in coffee-script.</p>
              <div>
              &nbsp;</div>
              <div>
              <span style="font-size:28px;">Katra </span>has one goal - to run StarTrek.bas games from the</div>
              <div>
              golden age of basic programming.</div>
              <div>
              &nbsp; &nbsp;&nbsp;</div>
              <div>
              &nbsp;</div>
              <div>
              &nbsp;</div>
              <div>
              &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ------*------ &nbsp;&nbsp;</div>
              <div>
              &nbsp; &nbsp; ------------- &nbsp; `--- &nbsp;------&#39; &nbsp;&nbsp;</div>
              <div>
              &nbsp; &nbsp; `-------- --&#39; &nbsp; &nbsp; &nbsp;/ / &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div>
              <div>
              &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;\\\\------- &nbsp;-- &nbsp; &nbsp; &nbsp; &nbsp;</div>
              <div>
              &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&#39;-----------&#39; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div>
              <div>
              &nbsp;</div>
              <div>
              &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;NCC - 1701</div>
              <div>
              &nbsp;</div>
              <div>
              &nbsp;</div>
              <div>
              &gt; <a href="/katra">Beam me up, Scotty!</a></div>
              <div>
              &nbsp;</div>
              <div>
              &nbsp;</div>
              """

      $table.addData
        id: 2
        author_id: 2
        category_id: 1
        status: 1
        created_on: '2013-03-13 09:22:20'
        updated_on: '2013-03-13 09:22:20'
        updated_by: 2
        title: 'How Many Space Needles Does It Take?'
        tags: ''
        body: """
              <p>
              I am .0099 Space Needles tall, and yet I weight a scant .00004 Space Needles.</p>
              <p>
              How many space needles tall are you?</p>
              <p>
              &nbsp;</p>
              <p>
              The Space Needle is 605 ft tall and weighs 9,550 tons.</p>
              """

      $table.addData
        id: 3
        author_id: 2
        category_id: 1
        status: 1
        created_on: '2013-06-01 09:22:20'
        updated_on: '2013-06-01 09:22:20'
        updated_by: 2
        title: 'About'
        tags: ''
        body: """
              <h3>Dark Overlord of Data is:</h3>

              <p><strong>a web page</strong></p>

              <p><em>created using <a href="http://exspresso.aws.af.cm/">Exspresso</a></em></p>

              <p><strong>bruce davidson</strong></p>

              <p><em>a software developer who lives in seattle with his wife and daughter, two cats, one dog, and an electric guitar</em></p>
              """

      ###
      $table.addData
        id: 4
        author_id: 2
        category_id: 1
        status: 1
        created_on: '2013-06-02 09:22:20'
        updated_on: '2013-06-02 09:22:20'
        updated_by: 2
        title: 'de Finibus Bonorum et Malorum'
        tags: ''
        body: """
              <p>Etiam turpis augue, pellentesque sed bibendum in, sollicitudin vitae velit. Maecenas egestas justo sed lorem mattis sodales. Etiam fringilla suscipit odio dapibus mattis. Praesent laoreet sapien sit amet eros tempus eget pharetra arcu pulvinar. Fusce porttitor dolor id purus volutpat facilisis. Vestibulum venenatis mauris a lectus egestas porttitor. Proin ut mi odio. Aliquam erat volutpat. Fusce egestas vulputate neque eu imperdiet. Phasellus tempus vulputate sollicitudin. Vestibulum lobortis odio eget mi gravida a lobortis ante ultrices. Suspendisse dignissim felis sit amet erat molestie tempus. Vestibulum ultricies elit massa, id tristique ligula.</p>
              <p>Quisque tempus lorem sed ligula elementum dapibus. Morbi diam nibh, posuere sit amet tincidunt a, adipiscing vitae nulla. Vivamus a enim diam. Morbi vestibulum vulputate mauris, eu lacinia diam iaculis a. Aliquam at mi sem, id imperdiet ante. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec lorem tellus, mattis at rutrum id, scelerisque quis nibh. Donec volutpat, leo eget ullamcorper ultrices, odio erat volutpat elit, commodo semper enim sapien eget sem. Proin mi arcu, laoreet eu bibendum sodales, eleifend at neque. Morbi mollis orci eget arcu molestie ac consequat nisl varius. Suspendisse sed dolor eros, ac luctus tellus. Nulla tincidunt tortor consequat dolor suscipit eu tempor urna ultricies. In vulputate auctor lorem, vel commodo orci condimentum sollicitudin.</p>
              """

      $table.addData
        id: 5
        author_id: 2
        category_id: 1
        status: 1
        created_on: '2013-06-03 09:22:20'
        updated_on: '2013-06-03 09:22:20'
        updated_by: 2
        title: 'Sed tempus semper nunc'
        tags: ''
        body: """
              <p>Suspendisse vitae dapibus odio. Aenean pretium hendrerit nunc, ac fermentum ipsum mattis ut. Integer vitae mauris vel augue porta ultrices. Nunc in mauris id diam luctus hendrerit ut ut nulla. Pellentesque sem elit, vestibulum ut euismod et, viverra ornare eros. Nulla nec augue sit amet ipsum tempor tincidunt ac in turpis. In sit amet sapien non massa tempor consectetur. Vestibulum malesuada convallis leo, ac congue tortor varius nec. Suspendisse laoreet nisi vitae dui tincidunt malesuada.</p>
              <p>Sed tempus semper nunc, quis ultrices mi aliquam sodales. Sed sed nunc massa. Ut vulputate posuere tellus at hendrerit. Aenean rhoncus dapibus libero, nec tempus ipsum fermentum sit amet. Nullam ipsum elit, dignissim vulputate aliquet ac, eleifend nec sapien. Praesent tincidunt tincidunt erat, at aliquam magna dapibus ut. Phasellus sagittis congue sem. Quisque tempus eros mauris. Pellentesque arcu sem, aliquet ac gravida a, fringilla vel nulla. Morbi elementum consequat turpis, nec mattis tellus viverra iaculis. Proin justo nulla, placerat vel suscipit condimentum, euismod sed nunc.</p>
              """

      $table.addData
        id: 6
        author_id: 2
        category_id: 1
        status: 1
        created_on: '2013-06-04 09:22:20'
        updated_on: '2013-06-04 09:22:20'
        updated_by: 2
        title: 'Suspendisse suscipit turpis'
        tags: ''
        body: """
              <p>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas fermentum sodales diam, nec euismod risus vestibulum in. Quisque eget facilisis felis. Vestibulum non suscipit eros. Donec tempor, justo eget posuere vulputate, purus dui elementum neque, in ornare turpis est in orci. Donec laoreet, purus nec ornare egestas, tortor sapien volutpat arcu, sed pellentesque dolor mauris sed elit. Sed vehicula ligula a orci tristique ornare. In vestibulum nisl luctus ipsum eleifend id porttitor metus rutrum. Maecenas posuere diam sed erat dapibus a ultrices ligula auctor. Vivamus leo erat, facilisis vitae sodales eu, vestibulum ac lectus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum nec justo a dui aliquet laoreet vel id tellus.</p>
              <p>Proin gravida quam at augue viverra sit amet semper ligula eleifend. Nulla at urna turpis. Donec vitae lectus tellus, non interdum leo. Maecenas quis leo id augue accumsan tempus nec tincidunt orci. Sed dignissim gravida leo, ut aliquam erat viverra quis. Duis blandit odio et mi sollicitudin a auctor mi elementum. Ut orci ligula, placerat sed iaculis eget, blandit a nulla. Nunc in aliquet purus. Nulla vitae sem et nunc gravida porttitor sit amet in risus. Morbi iaculis arcu vel erat blandit sed sodales mauris fermentum. Mauris id metus a urna tincidunt elementum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis rutrum ligula, vitae adipiscing est volutpat sed.</p>
              <p>Suspendisse suscipit turpis id purus scelerisque non sollicitudin arcu consectetur. Suspendisse auctor ullamcorper eleifend. Pellentesque tristique magna sed sapien luctus in tempor enim tempus. Duis quis orci urna, eget rhoncus lorem. Fusce ac laoreet lectus. Pellentesque aliquet condimentum eros sed fermentum. Quisque nec risus ipsum. Sed in lectus fringilla mauris hendrerit mattis vel at quam. In interdum eros nec erat egestas pulvinar. In ac dui felis, quis aliquam nulla. Mauris eleifend dapibus rutrum. Praesent vitae purus et odio porttitor ultricies. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Duis sed lorem ipsum. Donec elit quam, elementum eu mollis gravida, feugiat sed ligula.</p>
              """

      $table.addData
        id: 7
        author_id: 2
        category_id: 1
        status: 1
        created_on: '2013-06-05 09:22:20'
        updated_on: '2013-06-05 09:22:20'
        updated_by: 2
        title: 'Curabitur in justo orci'
        tags: ''
        body: """
              <p>Etiam lobortis justo vitae nisi feugiat bibendum nec id elit. Integer molestie mi rhoncus mi mattis vitae lobortis purus ornare. Sed massa turpis, vestibulum vitae molestie eget, porta eu justo. Integer nec orci a sem lacinia sodales. Vivamus risus purus, condimentum at posuere vel, condimentum non metus. Suspendisse id laoreet enim. Vivamus ullamcorper varius risus, id vehicula dui viverra nec. Quisque semper, justo ac pharetra sagittis, libero nisl fringilla eros, tincidunt tempor augue ante vel felis.</p>
              <p>
              <ul>
              <li>Vestibulum aliquam metus justo, vel dictum velit.</li>
              <li>Proin vitae odio arcu, quis semper ligula.</li>
              <li>Donec tristique turpis sed leo mollis iaculis.</li>
              <li>Vivamus eu sem non tortor bibendum accumsan.</li>
              <li>Phasellus volutpat ultricies leo, ac scelerisque elit ultrices tempor.</li>
              <li>Vestibulum tempor nibh bibendum dolor auctor fringilla porta ante pretium.</li>
              </ul>
              </p>
              <p>
              <ul>
              <li>Sed vitae nisl ante, a bibendum lacus.</li>
              <li>Mauris non odio tincidunt purus lacinia mattis.</li>
              <li>Donec at odio enim, nec laoreet urna.</li>
              </ul>
              </p>
              <p>
              <ul>
              <li>Curabitur in justo orci, sit amet gravida orci.</li>
              <li>Ut placerat aliquet neque, vitae molestie tellus hendrerit sed.</li>
              </ul>
              </p>
              """
      ###
