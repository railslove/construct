Feature: Builds

  Background:
    Given I am logged in
    And there is a github project
    And there is a codebase project
    And there are no queued jobs
    Given I am on the homepage
    Then there should be 2 projects
    
Scenario: Rebuilding Builds
  When I follow "construct-success"
  And I follow "master"
  And I press "Rebuild this commit"
  Then I should see "Build 69ca694a2 rebuilding for construct-success"

Scenario: Building the latest
  When I follow "construct-success"
  And I follow "master"
  And I press "Fetch & Build Latest"
  Then I should see "Building latest for master"