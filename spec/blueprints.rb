require 'machinist/active_record'

Project.blueprint(:by_star) do
  name "by_star"
  instructions File.read(File.dirname(__FILE__) + "/fixtures/build_instructions")
end

Project.blueprint { }