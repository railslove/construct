Feature: Login
  In order to login and use the admin stuff
  As an admin
  I want a way to do that
  
  Scenario: Logging in
    Given I am on the homepage
    And there is a person called "admin" with the password "password"
    And "admin" is an admin
    When I follow "Login"
    When I fill in "Name" with "admin"
    And I fill in "Password" with "wrong password"
    And I press "Login"
    Then I should see "Could not log you in. Please try again."
    When I fill in "Name" with "admin"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should see "You have successfully logged in."
    
