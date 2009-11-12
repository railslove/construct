require 'machinist/active_record'

Project.blueprint { }

Project.blueprint(:by_star) do
  name "by_star"
end