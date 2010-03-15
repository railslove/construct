Feature: Notifications
  In order to be notified of the build status
  As a user
  I want to receive an email
  
  Background:
    Given I am logged in
    And there is a github project
    And there are no queued jobs
    And my email address is "test@example.com"

  @wip
  Scenario: Receiving an email notification of the build
    When the latest build for construct-success/master is ran
    When "test@example.com" opens the email
    Then they should see "[construct] SUCCESS! construct-success - 69ca694a2" in the email subject
    When they follow "the build page" in the email
    Then I should see "69ca694a2" as the latest
    Then I should see the latest is successful

  
