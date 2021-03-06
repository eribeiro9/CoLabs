@CoLabs = {}
CoLabs.methodNames = []
CoLabs.methods = (obj) ->
  Meteor.methods obj
  ###
  that = this
  wrapFn = (fn) -> (args...) ->
    try
      return fn.apply that args...
    catch err
      wasDisabled = not Logger.isEnabled
      Logger.enable()
      console.error err
      if wasDisabled then Logger.disable()
      throw err
      
  for name,fn of obj
    CoLabs.methodNames.push name
    method = {}
    method[name] = wrapFn fn
    Meteor.methods method
  ###

CoLabs.methods
  updateUser: (obj) ->
    user = Meteor.users.findOne Meteor.userId()
    emails = if obj.email isnt '' then [address: obj.email, verified: false] else false
    
    # Check if already verified
    for email in user.emails.filter((e) -> e.verified)
      if obj.email is email.address then emails[0].verified = true
    
    Meteor.users.update Meteor.userId(), $set:
      emails: emails or user.emails
      avatar: obj.avatar or obj.identiconHex
      firstName: obj.firstName
      lastName: obj.lastName
      description: obj.description
      age: obj.age
      skills: obj.skills
      interests: obj.interests
      identiconHex: obj.identiconHex

  updateName: (id, newName) ->
    Meteor.users.update id, $set:
      name: newName
    
  sendVerificationEmail: (userId) ->
    if Meteor.isServer then Accounts.sendVerificationEmail userId