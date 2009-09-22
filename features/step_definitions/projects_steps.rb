Given /^there is a payload of$/ do |payload|
  post 'receive', :payload => payload
end
