Feature: Setup

  Background:
    Given I am logged in

  Scenario: First timers should "go through the motions"
    And I am on the homepage
    Then I should see "Hi there!"
    When I follow "Github"
    Then I should see "Github, eh?"
    When I follow "Setup"
    When I follow "Codebase"
    Then I should see "Codebase, eh?"
    Given there is a github project
    And I am on the homepage
    Then I should see "So you've setup a repository."
    When the latest build for construct-success/master is ran
    Given I am on the homepage
    Then I should not see "So you've setup a repository."
