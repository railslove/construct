Given /^there is a github payload of$/ do |payload|
  post 'github', :payload => payload
end
