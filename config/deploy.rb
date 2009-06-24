default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "fixmycitydc"
set :repository,  "git@github.com:skeevis/FixMyCity.git"

set :port, 22
#set :keep_releases, 5

#set :deploy_via, :remote_cache
set :scm, :git
set :branch, "master"

task "production" do
  set :rails_env, "production"
  set :deploy_to, "/home/zvi/rails/fixmycitydc"
  set :user, "zvi"
  set :location, "projects.skeevisarts.com"
#  set :location, "beta.workstreamer.com"
  set :use_sudo, false
  set :deploy_via, :copy

  role :app, location
  role :web, location
  role :db,  location, :primary => true
end

#############################################################
# Deploy for Passenger
#############################################################

namespace :deploy do
  desc "Restarting mod_rails with restart.txt and restarting god, workling and fetchmail"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do
#      run "cd #{release_path} && rake asset:packager:build_all"
 #     run "god && god load #{current_path}/config/environments/#{rails_env}.god && god restart workling"
    end
  end
end

after "deploy" do
  end
after "deploy", "deploy:cleanup"

after "rollback" do
end