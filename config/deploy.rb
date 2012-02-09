$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "demo-delmar"
set :rails_env, "production"
set :domain, "rails@dev.progforce.com" #TODO: update user and host
set :deploy_to, "/srv/rails/#{application}"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :rvm_ruby_string, '1.9.2@delmar-demo'
set :rvm_type, :user

set :scm, :git
set :repository,  "git://github.com/tamtamchik/some-project.git"
set :branch, "master" # git branch can be changed.
set :deploy_via, :remote_cache

role :web, domain
role :app, domain
role :db,  domain, :primary => true

# Restart Unicorn rules
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end

