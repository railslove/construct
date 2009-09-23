load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
require 'deprec'

set :application, "gitpilot"
set :domain,      "gitpilot.com"
set :repository,  "git://github.com/radar/construct.git"

set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :user, "deploy"
set :branch, "master"


set :ruby_vm_type,      :mri        # :ree, :mri
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :sqlite      # :mysql, :postgresql, :sqlite

set(:mysql_admin_pass) { db_password }

ssh_options[:forward_agent] = true
# set :packages_for_project, %w(libmagick9-dev imagemagick libfreeimage3) # list of packages to be installed
# set :gems_for_project, %w() # list of gems to be installed

# Update these if you're not running everything on one host.
role :app, domain
role :web, domain
role :db, domain, :primary => true

# If you aren't deploying to /opt/apps/#{application} on the target
# servers (which is the deprec default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

before 'deploy:cold', 'deploy:upload_database_yml'
before 'deploy:cold', 'deploy:ping_ssh_github'
after 'deploy:symlink', 'deploy:create_symlinks'
after 'deploy:symlink', 'deploy:install_gems'
after 'deploy:symlink', 'deploy:migrate'
after "deploy:symlink", "deploy:update_crontab"
after "deploy:symlink", "deploy:god"
after "deploy:symlink", "deploy:live_updater"
after "deploy:symlink", "deploy:jobs_worker"

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.app.restart
  end

  task :start, :roles => :app, :except => { :no_release => true } do
    top.deprec.app.restart
  end

  desc "Uploads database.yml file to shared path"
  task :upload_database_yml, :roles => :app do
    put(File.read('config/database.yml'), "#{shared_path}/config/database.yml", :mode => 0644)
  end

  desc "ssh git@github.com"
  task :ping_ssh_github do
    run 'ssh -o "StrictHostKeyChecking no" git@github.com || true'
  end

  desc "Install gems required for production"
  task :install_gems do
    sudo "echo 'Installing gems...'"
    run "cd #{current_path} && RAILS_ENV=production sudo rake gems:install"
  end
  
  desc "Symlinks database.yml file from shared folder"
  task :create_symlinks, :roles => :app do
    run "rm -f #{current_path}/config/database.yml"
    run "ln -s #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end
  
  desc "Run the jobs worker"
  task :jobs_worker, :continue => true do 
    run "killall -q jobs_worker || true"
    # resurrect the jobs worke
    run "cd #{current_path} && screen -dmS jobs_worker ./script/jobs_worker"
  end

end

namespace :rake do
  task :invoke do
    if ENV['COMMAND'].to_s.strip == ''
      puts "USAGE:   cap rake:invoke COMMAND='db:migrate'"
    else
      run "cd #{current_path} && sudo rake #{ENV['COMMAND']} RAILS_ENV=production"
    end
  end
end

desc "Returns last lines of log file. Usage: cap log [-s lines=100] [-s rails_env=production]"
task :log do
  lines     = configuration.variables[:lines] || 100
  rails_env = configuration.variables[:rails_env] || 'production'
  run "tail -n #{lines} #{deploy_to}/#{shared_dir}/log/#{rails_env}.log" do |ch, stream, out|
    puts out
  end
end

namespace :db do
  set :db_user, 'root'
  set :db_name, "#{application}_production"

  desc "Dumps target database into development db"
  task :sync do
    env   = ENV['RAILS_ENV'] || ENV['DB'] || 'production'
    file  = "#{application}-#{Time.now.to_i}.sql.bz2"
    remote_file = "#{shared_path}/log/#{file}"
    backup
    puts rsync = "rsync -v --stats --progress #{user}@#{domain}:#{remote_file} tmp"
    `#{rsync}`
    puts depackage = "bzcat tmp/#{file} | mysql -uroot #{db_name}_development"
    `#{depackage}`
  end

  task :backup do
    env   = ENV['RAILS_ENV'] || ENV['DB'] || 'production'
    file  = "#{application}-#{Time.now.to_i}.sql.bz2"
    remote_file = "#{shared_path}/log/#{file}"
    run "mysqldump -u#{db_user} #{db_name}_#{env} | bzip2 > #{remote_file}" do |ch, stream, out|
      puts out
    end
  end
end