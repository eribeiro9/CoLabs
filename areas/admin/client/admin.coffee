Template.admin.helpers
  buttonRunTerminal: -> Render.buttonSave
    id: 'runTerminal'
    class: 'form-control'
    icon: 'terminal'
    text: 'Run'
    onclick: -> console.log eval $('[name=command]').val()

Template.enableLogs.onCreated = ->
  Session.set 'logEnabled', Logger.isEnabled?

Template.enableLogs.helpers
  isEnabled: -> Session.get 'logEnabled'
  
Template.enableLogs.events
  "click #enableLogs": ->
    toast.info 'Clicked', Logger.isEnabled, 1000
    if Logger.isEnabled then Logger.disable()
    else Logger.enable()
    Session.set 'logEnabled', Logger.isEnabled

Template.clearLogs.events
  "click #clearLogs": -> Logger.clear()