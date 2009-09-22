Then /^I should see "([^\"]*)" as the latest$/ do |sha|
  Commit.all.map(&:sha)
  Nokogiri::HTML(response.body).xpath("//div[@id='latest']").text.should include(sha)
end
