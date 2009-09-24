Feature: Projects

  Background:
    Given I am logged in
    And there is a github payload of
      """
        {
          "repository": 
            {
              "name": "by_star",
              "private": false,
              "watchers": 98,
              "fork": false,
              "url": "http://github.com/radar/by_star",
              "open_issues": 0,
              "homepage": "http://runcoderun.com/radar/by_star",
              "description": "Lets you find ActiveRecord objects by year, month, fortnight, week and more!",
              "forks": 2,
              "owner": 
                {
                  "name": "radar",
                  "email": "radarlistener@gmail.com"
                }
            },
          "after": "8d0f748fa07b08d88afc69568f7d4f7207b9ee50",
          "commits": 
            [
              {
                "added": [],
                "modified": ["lib/by_star.rb","spec/by_star_spec.rb"],
                "author": 
                  {
                    "name": "Ryan Bigg",
                    "email": "radarlistener@gmail.com"
                  },
                "removed": [],
                "timestamp": "2009-08-28T16: 52: 49-07: 00",
                "url": "http://github.com/radar/by_star/commit/6431ae852cb2574263bfa8f4dfaa85cff55db5eb",
                "id": "6431ae852cb2574263bfa8f4dfaa85cff55db5eb",
                "message": "ArgumentError will only be raised on versions < 1.8.7."
              },
              {
                "added": [],
                "modified": ["README.markdown", "lib/by_star.rb"],
                "author": 
                  {
                    "name": "Ryan Bigg",
                    "email": "radarlistener@gmail.com"
                  },
                "removed": [],
                "timestamp": "2009-08-28T17: 39: 25-07: 00",
                "url": "http://github.com/radar/by_star/commit/8d0f748fa07b08d88afc69568f7d4f7207b9ee50",
                "id": "8d0f748fa07b08d88afc69568f7d4f7207b9ee50",
                "message": "Added documentation for the current weekend and current work week, provided method names."
              }
            ],
          "ref": "refs/heads/master",
          "before": "4b348f1466d1c73bf4cee17c9c377a4a207ea231"
        }
      """
    And there are no queued jobs
    Given I am on the homepage
    Then there should be 1 project

  Scenario: Viewing Projects
    When I follow "by_star"
    Then I should see "Build #0 - 6431ae852" as the latest
    
  Scenario: Rebuilding Builds
    When I follow "by_star"
    And I press "Rebuild"
    Then I should see "Build 6431ae852 rebuilding for by_star"
    
  
  Scenario: Rebuilding the same build in quick succession should fail
    When I follow "by_star"
    And I press "Rebuild"
    Then I should see "Build 6431ae852 rebuilding for by_star"
    When I press "Rebuild"
    Then I should not see "Build 6431ae852 rebuilding for by_star"
    Then I should see "Build 6431ae852 could not be built: This commit is already queued to build."
  
  
