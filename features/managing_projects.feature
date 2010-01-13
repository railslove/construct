Feature: Managing projects
  In order to manage projects
  As a user of the system
  I want absolute power!
  
  Background:
   Given there is a person called "admin" with the password "password"
   And I am logged in as "admin"
  
  Scenario: Hiding a project from the main screen
    When I follow "Manage Projects"

