Given /^there are no queued jobs$/ do
  Delayed::Job.delete_all
end

# Called anyway, even if the keys are commented out.
Given /^I am logged in$/ do
  basic_auth(CONSTRUCT["user"], CONSTRUCT["password"])
end

Given /^time is frozen$/ do
  time = "12-11-2009 07:00".to_time
  Time.stubs(:now).returns(time)
end

When /^the latest build for (.*?)\/(.*?) is ran$/ do |project, branch|
  first_build = Project.find_by_name!(project).branches.find_by_name!(branch).builds.first
  BuildJob.new(first_build.id, first_build.payload).perform
end

When /^I dump the page$/ do
  save_and_open_page
end