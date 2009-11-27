Given /^I am viewing the logs$/ do
  host! "logs.example.com"
end

Given /^there is a channel called "([^\"]*)"$/ do |name|
  channel = Channel.make(:name => name)
  channel.messages.make(:created_at => Time.now, :person => Person.make)
  channel.messages.make(:created_at => Time.now, :person => Person.make(:name => "AReallyLongName"))
  channel.messages.make(:created_at => Time.now - 1.day, :person => Person.make)
  channel.messages.make(:created_at => Time.now - 1.day, :person => Person.make(:name => "AReallyLongName"))
end
