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
end

Given /^there is a codebase project$/ do
  post 'codebase', :payload => payload("docjockey")
  ensure_authed
end


Then /^there should be (\d+) projects?$/ do |num|
  Project.count.should be(num.to_i)
end

# Test for success as we may receive 401.
def ensure_authed
  fail("The recieve URL /codebase is not skipping the authenticate before filter.") if response.code.to_i == 401
  response.should be_success
end

def payload(key)
  File.read("#{RAILS_ROOT}/spec/fixtures/#{key}")
end