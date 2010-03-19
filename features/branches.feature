Feature: Branches

  Background:
    Given I am logged in
    And there is a github project
    And there is a codebase project
    And there are no queued jobs
    When the latest build for construct-success/master is ran
    When the latest build for construct-success/win is ran
    When the latest build for construct-success/1.2.3 is ran
    Then there should be 4 branches
    Given I am on the homepage

  Scenario: Selecting a branch
    When I follow "construct-success"
    Then I should see "branches"
    When I follow "master"
    Then I should see "69ca694a2" as the latest
    Then I should see the latest is successful
    
    When I follow "branches"
    When I follow "win"
    Then I should see "3856a85bd" as the latest
    Then I should see the latest is successful
    
    When I follow "branches"
    And I follow "1.2.3"
    Then I should see "0d1c28dc" as the latest
    Then I should see the latest is successful
    
  Scenario: Branch settings
    When I follow "win"
    And I follow "Branch Settings"
    Then I should see "Branch Settings" within "h2"

  Scenario: Delete a branch
    Given I follow "win"
    And I follow "Branch Settings"
    When I follow "Delete this branch"
    Then I should see "Branch deleted" within ".flash"
    And there should be 3 branches
    And I should see "master" within "#branches"
    And I should see "1.2.3" within "#branches"
    And I should not see "win" within "#branches"
