require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Payload do
  it "builds a new payload" do
    Payload.for("construct", Grit::Repo.new(RAILS_ROOT), "82f3b808242f12907714d41161f95942842fcfb6").should eql(JSON.parse(<<-PAYLOAD
{
  "after": "25106659560d4eadad9622f4b3be77870e51b6fc", 
  "before": "111e836556bf4247cdf929b5f069041dc5348399", 
  "commits": [
    {
      "added": [], 
      "author": {
        "email": "me@bjeanes.com", 
        "name": "Bodaniel Jeanes"
      }, 
      "id": "82f3b808242f12907714d41161f95942842fcfb6", 
      "message": "Fixed colour specs", 
      "modified": [], 
      "removed": [], 
      "timestamp": "2009-11-17T11:42:54+10:00", 
      "url": "http:\/\/github.com\/radar\/construct\/commit\/82f3b808242f12907714d41161f95942842fcfb6"
    }
  ], 
  "ref": "refs\/heads\/master", 
  "repository": {
    "description": "", 
    "fork": false, 
    "forks": 0, 
    "homepage": "http:\/\/gitpilot.com", 
    "name": "construct-success", 
    "open_issues": 0, 
    "owner": {
      "email": "radarlistener@gmail.com", 
      "name": "radar"
    }, 
    "private": false, 
    "url": "http:\/\/github.com\/radar\/construct", 
    "watchers": 1
  }
}
    PAYLOAD
    ))
  end
  
end