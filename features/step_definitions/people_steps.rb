Given /^there is a person called "([^\"]*)" with the password "([^\"]*)"$/ do |name, password|
  Person.create!(:name => name, :password => password)
end

Given /^"([^\"]*)" is an admin$/ do |name|
  p = Person.find_by_name(name)
  p.update_attribute("admin", true)
end

Given /^I am logged in as "([^\"]*)"$/ do |name|
  Given "I am on the login page"
  When "I fill in \"Name\" with \"#{name}\""
  And  "I fill in \"Password\" with \"password\""
  And  "I press \"Login\""
  Then "I should see \"You have successfully logged in.\""
end
