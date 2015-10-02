
Meteor.publish 'allUsers', ->
  Meteor.users.find()

Meteor.publish 'allProjects', ->
  Projects.find()

Meteor.publish 'allMessages', ->
  Messages.find()

Meteor.publish 'thisUser', (id) ->
  Meteor.users.find _id:id
  
Meteor.publish 'thisUserByName', (username) ->
  Meteor.users.find username:username

Meteor.publish 'myProjects', ->
  #Logger.enable()
  console.log this.userId
  if this.userId then Projects.find users:this.userId
  else []
  
Meteor.publish 'project', (id) -> Projects.find _id:id

Meteor.publish('allInvitations', ->
    Invitations.find()
)

Meteor.publish('projectInvitations', (id) ->
    Invitations.find(
        project:id
    )
)

Meteor.publish 'userInvitations', (id) ->
    Invitations.find user:id

Meteor.users.allow
  update: (userId) -> this.userId?