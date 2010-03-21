namespace :ci do
  
  task :copy_config do
    File.open("#{Rails.root}/config/database.yml", "w") {|f| f.write database_yml }
  end

  desc "Prepare for CI and run entire test suite"
  task :build => ['ci:copy_config', 'db:create', 'db:migrate', 'cucumber'] do
  end

  def database_yml
    %Q{
development: &TEST
  adapter: mysql
  encoding: utf8
  database: constructa_#{Rails.root.basename.to_s}_test
  username: root
  password: 
test:
  <<: *TEST
cucumber:
  <<: *TEST
production:
  <<: *TEST
    }
  end
  
end