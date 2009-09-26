Feature: Branches

  Background:
    Given I am logged in
    And there is a github project
    And there is a codebase project
    And there are no queued jobs
    Given I am on the homepage

  Scenario: Selecting a branch
    When I follow "by_star"
    Then I should see "Branches"
    When I follow "master"
    Then I should see "6431ae852" as the latest
    When I follow "branches"
    When I follow "thomas"
    Then I should see "6431ae852" as the latest
