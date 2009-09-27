Feature: Projects

  Background:
    Given I am logged in
    And there is a github project
    And there is a codebase project
    And there are no queued jobs
    Given I am on the homepage
    Then there should be 2 projects

  Scenario: Viewing Github Project
    When I follow "by_star"
    When I follow "master"
    Then I should see "e52ccb1ce" as the latest

  Scenario: Viewing Codebase Project
    When I follow "Doc Jockey: Web App"
    Then I should see "0914d3308" as the latest

  
