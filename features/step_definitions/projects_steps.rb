Given /^there is a github project$/ do
  
  # "master" branch latest commit
  post 'github', :payload => payload("construct-success-latest")
  ensure_authed
  
  # "master" branch, earlier commit
  post 'github', :payload => payload("construct-success")
  ensure_authed
  
  # "win" branch
  post 'github', :payload => payload("construct-success-branch")
  ensure_authed
  
  # "1.2.3" branch
  post 'github', :payload => payload("construct-success-branch-2")
  ensure_authed
end

Given /^there is a codebase project$/ do
  post 'codebase', :payload => payload("docjockey")
  ensure_authed
end

Then /^the returned feed should contain the following projects$/ do |table|
  project_names = Nokogiri::XML(response.body).xpath("//Project/@name").to_a.map(&:text)
  table.diff!(project_names.map(&:to_a))
end

# Test for success as we may receive 401.
def ensure_authed
  fail("The recieve URL /codebase is not skipping the authenticate before filter.") if response.code.to_i == 401
  response.should be_success
end

def payload(key)
  File.read("#{RAILS_ROOT}/spec/fixtures/#{key}")
end