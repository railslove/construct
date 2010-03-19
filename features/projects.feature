Feature: Projects

  Background:
    Given I am logged in
    And time is frozen
    And there is a github project
    And there is a codebase project
    And there are no queued jobs
    And I am on the homepage

  Scenario: Viewing Github Project
    When the latest build for construct-success/master is ran
    When I follow "construct-success"
    When I follow "master"
    Then I should see "69ca694a2" as the latest
    Then I should see the latest is successful
  
  @wip
  Scenario: Viewing Codebase Project
    When the latest build for Doc Jockey: Web App/master is ran
    When I follow "Doc Jockey: Web App"
    Then I should see "7906cfa68" as the latest
    Then I should see the latest is successful
    
  Scenario: Getting the feed back
    Given I am on the projects xml
    Then the returned feed should contain the following projects
      | Doc Jockey: Web App (master) |
      | construct-success (master)   |
      | construct-success (win)      |
      | construct-success (1.2.3)    |
  
  Scenario: Delete a project
    Given I follow "Doc Jockey: Web App"
    And I follow "Project Settings"
    When I follow "Delete this project"
    Then I should see "OMG! you just nuked the entire Doc Jockey: Web App project."
    And there should be 1 project
    And I should see "construct-success" within "#projects"
    And I should not see "Doc Jockey: Web App" within "#projects"
