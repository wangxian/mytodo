define (require, exports, module)->
  $        = require 'jquery'
  Backbone = require 'gallery/backbone/0.9.10/backbone.js'
  _        = require 'gallery/underscore/1.4.4/underscore.js'

  Backbone.emulateHTTP = false
  Backbone.emulateJSON = false

  TodoModelDef = Backbone.Model.extend
    # must set if HTTP
    idAttribute  : "_id"
    defaults:
      # "_id"      : 0
      # "post_date": '',
      "finished" : 0,
      "title"    : ''
    urlRoot: '/todo'

  TodoListDef  = Backbone.Collection.extend
    model: TodoModelDef
    url  : ->
      '/todo?'+ (new Date()).getTime()

    initialize: ->

  TodoItemViewDef = Backbone.View.extend
    tagName  : 'li'
    className: 'item'
    events   :
      'click .finish' : 'finish'
      'click .delete' : 'delete'
      'click .renew'  : 'renew'
      'dblclick .new' : 'editing'
      'blur input'    : 'editOK'
      'keypress input': 'pressEnter'
    template : ->
      tpl = """
            <input type="text" />
            <span class="<%= it.get('finished')?'del':'new' %>"><%= it.get('title') %></span>
            <span class="date"><%= (new Date(it.get('post_date'))).toLocaleString() %></span>

            <% if(it.get('finished')){ %>
            <a href="javascript: void(0);" class="renew">恢复</a>
            <% }else{ %>
            <a href="javascript: void(0);" class="finish">完成</a>
            <% } %>

            <a href="javascript: void(0);" class="delete">删除</a>
            """

      _.template(tpl, {it: this.model});

    initialize: ->
      this.model.on('change', this.render, this)
    render    : ->
      this.$el.html this.template()
      return this
    finish : ->
      this.model.save {finished: 1}
    renew  : ->
      this.model.save {finished: 0}
    delete : ->
      this.model.destroy()
      this.$el.remove();
    editing: (e)->
      if this.$el.find('.new').width() > 740
        width = 740
      else
        width = this.$el.find('.new').width()

      this.$el.addClass('editing')
      this.$el.find('input').val( this.$el.find('.new').text() )
          .width( width )
          .focus()

    editOK: (e)->
      this.$el.removeClass('editing')
      title = this.$el.find('input').val()
      # this.$el.find('.new').text(title)
      unless title is this.model.get('title')
        this.model.save {'title', title}
    pressEnter: (e)->
      if e.keyCode is 13
        $(e.currentTarget).blur()

  MainViewDef  = Backbone.View.extend
    el    : $('.main')
    events:
      'click .post input[type="button"]': "newTodo",
      'keypress .post input[type="text"]': "pressEnter"
    initialize: ->
      TodoList.on('add', this.addOne, this)
      TodoList.on('reset', this.addAll, this)

      TodoList.fetch()

    addAll: ->
      this.$(".todos ul").empty()
      TodoList.each(this.addOne)

    addOne: (model)->
      item = new TodoItemViewDef({"model": model});
      this.$(".todos ul").prepend( item.render().el )

    newTodo: ->
      _title = this.$('.post input[type="text"]').val()
      if _title
        TodoList.create({title: _title, finished: 0})

    pressEnter: (e)->
      if e.keyCode is 13
        this.newTodo()
        e.currentTarget.value = ''


  TodoList = new TodoListDef;
  MainView = new MainViewDef

  window.TodoList = TodoList