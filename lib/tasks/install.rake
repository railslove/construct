task :install => :environment do
  if `whoami`.strip != 'root'
    puts "\e[0;31mThis installer must be ran by root. We promise not to do anything nasty!\e[0m"
    exit!
  else
    # Do something?
  end
end