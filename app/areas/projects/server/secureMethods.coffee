
removeUserFromProject = (data)->
  project = Projects.findOne data.projectId
  users = project.users.filter (id)-> id isnt data.userId
  admins = project.admins.filter (id)-> id isnt data.userId
  # TODO: Handle case when no admins remain
  if users.length is 0 then Projects.remove data.projectId
  else Projects.update data.projectId, $set:
    users: users
    admins: admins

removeProjectFromUser = (data)->
  user = Meteor.users.findOne data.userId
  projects = user.projects.filter (id)-> id isnt data.projectId
  Meteor.users.update data.userId, $set:
    projects: projects

removeInviteNotification = (data)->
  Notifications.remove
    userId: data.userId
    'data.projectId': data.projectId

CoLabs.methods
  createProject: (data)->
    if CoLabs.isVerifiedUser()
      userId = Meteor.userId()
      Projects.insert {
        name: data.name
        description: data.description
        createdAt: new Date()
        users: [userId]
        admins: [userId]
        skills: []
        interests: []
        conversation: []
        identiconHex: CoLabs.encodeAsHexMd5(data.name.concat Date.now().toString())
        type: 'project' }, (err, doc)->
          unless err?
            projects = Meteor.user().projects
            projects.push doc
            Meteor.users.update userId, $set:
              projects: projects
  removeUserFromProject: (data)->
    project = Projects.findOne data.projectId
    if Meteor.userId() in project.admins or Meteor.userId() is data.userId
      removeUserFromProject data
      removeProjectFromUser data
      removeInviteNotification data
