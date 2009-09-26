Given /^there is a github project$/ do
  post 'github', :payload => YAML::load_file("#{RAILS_ROOT}/spec/fixtures/payload.yml")["github"].to_json
  # Test for success as we may receive 401.
  fail("The recieve URL /github is not skipping the authenticate before filter.") if response.code.to_i == 401
  response.should be_success
end

Given /^there is a codebase project$/ do
  post 'codebase', :payload => YAML::load_file("#{RAILS_ROOT}/spec/fixtures/private_payload.yml")["codebase"].to_json
  # Test for success as we may receive 401.
  fail("The recieve URL /codebase is not skipping the authenticate before filter.") if response.code.to_i == 401
  response.should be_success
end


Then /^there should be (\d+) projects?$/ do |num|
  Project.count.should be(num.to_i)
end
