Given /^there are no queued jobs$/ do
  Delayed::Job.delete_all
end

Given /^I am logged in$/ do
  basic_auth(CONSTRUCTA["user"], CONSTRUCTA["password"])
end

When /^I dump the page$/ do
  save_and_open_page
end