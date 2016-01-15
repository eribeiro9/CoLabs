// TODO: app.pages and app['component name']
// app.modals.loginOrRegister.isVisible()
// app.pages.splash.buttons.findProject.click()
// app.pages.splash.buttons.findUser.click()
// app.pages.profile.buttons.resendEmail.click()
// app.views.toasts(0).isVisible()
// app.views.toasts(0).contains('Success')

require.call(this, '../lib/util.coffee')
var app = require('../lib/app.js')

module.exports = function() {
  this.Given(/^I am a logged in, unverified user$/, function () {
    browser.url(app.baseUrl)
    client.waitForExist(app.views.nav.profileInfo)
  })
  
  var page = app.pages.profile

  this.When(/^I click on the verify email button$/, function () {
    page.views.verifyEmailButton.click()
  })
}
