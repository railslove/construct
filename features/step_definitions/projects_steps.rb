Given /^there is a payload of$/ do |payload|
  post 'github', :payload => payload
end
