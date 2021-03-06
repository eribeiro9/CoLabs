Feature: Send & Receive messages

  As a user
  I want to send messages
  So that another user can read them

  Scenario: Create 3 users
    Given I am at the splash page
    When I create user "test"
    Then I sign out
    Given I am at the splash page
    When I create user "test2"
    Then I sign out
    Given I am at the splash page
    When I create user "test3"
    Then I sign out

  Scenario: User1 messages User2
    Given I am signed in as "test"
    And I am at the user test2 page
    When I click message user
    Then I see the "test2" label
    When I send "Hey there"
    Then I see a new message
    And I sign out

  Scenario: User2 nav badge
    Given I am signed in as "test2"
    Then I see a nav badge
    Given I am at the inbox page
    When I click the first message
    Then I don't see a nav badge

  Scenario: User2 messages User3
    Given I am at the user test3 page
    When I click message user
    And I send "Hey there"
    Then I see a new message

  @ignore
  Scenario: User2 favorites User1
    Given I am at the inbox page
    When I favorite "test3"
    Then "test3" is at the top of the contact list

  @ignore
  Scenario: User2 sorts message list
    Given I am at the inbox page
    When I order message list by favorite
    Then "test3" is at top of the message list
    When I order message list by time
    Then "test" is at the top of the message list
    And I sign out

  Scenario: Clear users
    When I remove all users
    Then No users remain
