Template.profileEdit.events
  'submit form':(e) ->
    e.preventDefault()
    id=Meteor.userId()
    longTagString=e.target.tagTextBox.value
    allTags=longTagString.trim().split(" ")

    if allTags.length==1 and allTags[0]==""
      allTags=[]

    Meteor.users.update(
      {_id:id},
      {$set:
        {
          avatar: e.target.avatarPathTextBox.value,
          firstName: e.target.firstNameTextBox.value,
          lastName: e.target.lastNameTextBox.value,
          age: e.target.ageTextBox.value
          interests:allTags
        }
      }
    )

getConcatTags=()->
  strings=""
  for tag in getCurrentInterests()
    strings=strings+" "+tag
  strings.substring(1,strings.length)

getCurrentInterests=()->
    Session.get("tempInterests")

Template.profileEdit.helpers
  concatTags:()->
    getConcatTags()

  currentInterests:()->
    getCurrentInterests()

  saveInterestsToSession:()->
    Session.set("tempInterests",Meteor.user().interests)
