# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
task(:default).clear

namespace :ember do
  ember = Rails.root.join('client', 'node_modules', '.bin', 'ember')

  desc 'Build the Ember app'
  task :build do
    if File.exist? ember
      sh "cd #{Rails.root.join('client')} && #{ember} build", verbose: false
    else
      fail "Ember binary missing: #{ember}"
    end
  end

  desc 'Run the Ember tests'
  task :test do
    if File.exist? ember
      sh "cd #{Rails.root.join('client')} && #{ember} test --reporter dot", verbose: false
    else
      fail "Ember binary missing: #{ember}"
    end
  end
end

if Rails.env.test? || Rails.env.development?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)
  task default: :rubocop

  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new(:scss_lint)
  task default: :scss_lint

  task default: :spec

  task default: 'ember:test'
end

if defined? RSpec
  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end

  task spec: 'ember:build'
end

task default: "bundler:audit"
