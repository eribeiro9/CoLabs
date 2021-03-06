#Sends out email and then logs the person in. We should think about not allowing the user to log in
#until the email verification link has been clicked

Accounts.onCreateUser (options, user) ->
  user.profile ?= {}
  user.projects ?= []
  user.identiconHex ?= CoLabs.encodeAsHexMd5(user.username.concat Date.now().toString())
  user.avatar ?= ''
  user.age ?= ''
  user.interests ?= []
  user.skills ?= []
  user.type ?= 'user'
  user.contacts ?= []
  user.conversations ?= []
  user.emails ?= []
  user.firstName ?= ''
  user.name ?= user.username
  user.description ?= ''
  
  last = null
  checkIfReady = ->
    last = Meteor.setTimeout (->
      if user.emails.length > 0 then Accounts.sendVerificationEmail user._id
      else checkIfReady()
    ), 1000
  
  Meteor.setTimeout checkIfReady, 1000
  Meteor.setTimeout (-> clearTimeout last), 10000
  
  user