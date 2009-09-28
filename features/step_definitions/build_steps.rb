Then /^I should see "([^\"]*)" as the latest$/ do |sha|
  last_build_text.should include(sha)
end

Then /^I should see the latest is (.*?)$/ do |status|
  last_build_text.should include(status)
end


def last_build_text
  Nokogiri::HTML(response.body).xpath("//div[@id='last_build']").text
end