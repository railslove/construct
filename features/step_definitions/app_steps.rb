Given /^there are no queued jobs$/ do
  Delayed::Job.delete_all
end
