#Sends out email and then logs the person in. We should think about not allowing the user to log in
#until the email verification link has been clicked

Accounts.onCreateUser (options,user) ->
  user.profile = {};
  user.projects = {};

  Meteor.setTimeout ->
    Accounts.sendVerificationEmail(user._id)
  ,2000
  console.log("User Verification Email has been sent out")
  user