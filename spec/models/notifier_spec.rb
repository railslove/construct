require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Notifier, "successful builds" do
  before do
    payload = payload("construct-success")
    @build = GithubBuild.setup(payload).start
    BuildJob.new(@build.id, @build.payload).perform
    @build.reload
  end
  
  subject { Notifier.deliver_build(@build) }
  
  it "sends a notification of success" do
    subject.should deliver_to('test@example.com')
    subject.subject.should include("SUCCESS!")
    subject.should have_text(/Build successful!/)
  end
  
end

describe Notifier, "failing builds" do
  before do
    payload = payload("construct-success")
    @build = GithubBuild.setup(payload).start
    @build.status = "failed"
    @build.save!
  end
  
  subject { Notifier.deliver_build(@build) }
  
  it "sends a notification of failure" do
    subject.should deliver_to('test@example.com')
    subject.subject.should include("FAILURE!")
    subject.should have_text(/Build failed!/)
  end
  
end