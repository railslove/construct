# ActionMailer::Base.smtp_settings = {
#   :address => "smtp.yourserver.com",
#   :port => '25',
#   :domain => "yourserver.com",
#   :authentication => :plain,
#   :user_name => "test@example.com",
#   :password => "password"
# }

ActionMailer::Base.default_url_options[:host] = "example.com"