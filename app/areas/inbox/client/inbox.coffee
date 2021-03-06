userExists = (id)-> Meteor.users.findOne(id)?

splitTimeStamp = (timeStamp)->
  timeStamp = new Date timeStamp unless timeStamp.getDate?
  date: timeStamp.toLocaleDateString()
  time: timeStamp.toLocaleTimeString()

clean = (timeStamp) ->
  today = (new Date()).toLocaleDateString()
  {date, time} = splitTimeStamp timeStamp
  if date is today then "Today, #{time}" else "#{date}, #{time}"

inbound = (id)-> Meteor.userId() is Messages.findOne(id).to

favorite = (id)->
  contacts = Meteor.user().contacts
  for contact in contacts
    return contact.favorite if id is contact.contact
  false

UI.registerHelper 'timeOf', (id)-> clean Messages.findOne(id).timeStamp

UI.registerHelper 'preview', (id)->
  message = Messages.findOne(id).message
  if message.length < 50 then message else message.slice(0, 50) + '...'

UI.registerHelper 'contactExists', (id)-> userExists id

UI.registerHelper 'contactNameExists', (name)-> Meteor.users.findOne(username:name)?

Template.previousContacts.helpers
  contactList: ->
    contacts = Meteor.user().contacts
    contacts?.sort (a, b)-> b.favorite - a.favorite

Template.previousContact.onCreated ->
  console.log @
  @subscribe 'oneUser', @data.contact

Template.previousContact.helpers
  favoriteButton: -> Render.button
    icon: if isFavorite @contact then 'star' else 'star-o'
    class: 'pull-right'
    text: 'Favorite'
    type: 'info'
    dataId: @contact
    onclick: ->
      # TODO: May want to add an event handler instead of inserting into page
      Meteor.call 'toggleContact', @data 'id'
  contactExists: (contactId)-> userExists contactId

Template.previousContact.events
  'click .conversation': (event)->
    $elem = $ event.currentTarget
    if $elem.hasClass 'media-body' then $elem = $elem.parent()
    Router.go "/inbox/#{Meteor.users.findOne($elem.data 'id').username}"


sendTo window, isFavorite: (id) ->
  for c in Meteor.user().contacts
    if c.contact is id then return c.favorite


messageSort = (value)->
  if value? then Session.set 'messageSort', value else Session.get 'messageSort'

Template.messageList.onCreated ->
  messageSort 'time' unless messageSort()?

Template.messageList.helpers
  isTime: -> messageSort() is 'time'
  isUnread: -> messageSort() is 'unread'
  isInbound: -> messageSort() is 'inbound'
  isFavorite: -> messageSort() is 'favorite'
  isTimeActive: -> if messageSort() is 'time' then 'active'
  isUnreadActive: -> if messageSort() is 'unread' then 'active'
  isInboundActive: -> if messageSort() is 'inbound' then 'active'
  isFavoriteActive: -> if messageSort() is 'favorite' then 'active'
  conversationList: ->
    conversations = Meteor.user().conversations
    switch messageSort()
      when 'time'
        conversations?.sort (a, b)->
          Messages.findOne(b.message).timeStamp - Messages.findOne(a.message).timeStamp
      when 'unread'
        conversations?.sort (a, b)->
          #TODO: Check if inbound before getting read status
          Messages.findOne(a.message).read - Messages.findOne(b.message).read
      when 'inbound'
        conversations?.sort (a, b)-> inbound(b.message) - inbound(a.message)
      when 'favorite'
        conversations?.sort (a, b)-> favorite(b.contact) - favorite(a.contact)
    conversations

Template.messageList.events
  'change .sortSelector': (event)->
    $elem = $ event.currentTarget
    messageSort $elem.val() if $elem.is(':checked')

Template.messageDetails.onCreated ->
  @subscribe 'oneMessage', @data.message
  @subscribe 'oneUser', @data.contact

Template.messageDetails.helpers
  favorite: (id) -> favorite id
  inbound: (id) -> inbound id
  unread: (id) -> not Messages.findOne(id).read

Template.messageDetails.events
  'click .conversation': (event)->
    $elem = $ event.currentTarget
    unless $elem.hasClass 'media' then $elem = $elem.parent()
    Router.go "/inbox/#{Meteor.users.findOne($elem.data 'id').username}"
