Feature: Builds

  Background:
    Given I am logged in
    And there is a github project
    And there is a codebase project
    And there are no queued jobs
    Given I am on the homepage
    Then there should be 2 projects
    
Scenario: Rebuilding Builds
  When I follow "by_star"
  And I follow "master"
  And I press "Rebuild this commit"
  Then I should see "Build e52ccb1ce rebuilding for by_star"
  

Scenario: Rebuilding the same build in quick succession should fail
  When I follow "by_star"
  And I follow "master"
  And I press "Rebuild this commit"
  Then I should see "Build e52ccb1ce rebuilding for by_star"
  When I press "Rebuild this commit"
  Then I should not see "Build e52ccb1ce rebuilding for by_star"
  Then I should see "There is already a build in progress for e52ccb1ce"
