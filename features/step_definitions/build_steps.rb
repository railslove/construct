Then /^I should see "([^\"]*)" as the latest$/ do |sha|
  Nokogiri::HTML(response.body).xpath("//div[@id='last_build']").text.should include(sha)
end
