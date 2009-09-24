Given /^there is a github payload of$/ do |payload|
  post 'github', :payload => payload
  # Test for success as we may receive 401.
  fail("The recieve URL /github is not skipping the authenticate before filter.") if response.code.to_i == 401
  response.should be_success
end

Then /^there should be (\d+) project$/ do |num|
  Project.count.should be(num.to_i)
end
