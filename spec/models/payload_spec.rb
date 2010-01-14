require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Payload do
  it "builds a new payload" do
    Payload.for("construct", Grit::Repo.new(RAILS_ROOT), "master", "82f3b808242f12907714d41161f95942842fcfb6").should eql(JSON.parse(<<-PAYLOAD
{
  "after": "111e836556bf4247cdf929b5f069041dc5348399", 
  "before": "241e393f5e38a8fe7891a6db46680b466f58c9ed", 
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
      "timestamp": null, 
      "url": null
    }
  ], 
  "ref": "refs\/heads\/master", 
  "repository": {
    "name": "construct"
  }
}
    PAYLOAD
    ))
  end
  
  # Regression testing.
  it "builds a new payload for the latest commit" do
    lambda { Payload.for("construct", Grit::Repo.new(RAILS_ROOT), "master", `git rev-parse HEAD`.strip) }.should_not raise_error
  end
  
end