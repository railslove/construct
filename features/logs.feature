Feature: Logs

Scenario: Viewing messages
  Given time is frozen
  And there is a channel called "rubyonrails"
  And there is a channel called "railsbridge"
  And I am viewing the logs
  And I am on the homepage
  Then show me the page
  When I follow "rubyonrails"
  Then show me the page
  Then I should see "November 12 2009"
  When I follow "26th November, 2009"
  Then I should see "Blah"



  
