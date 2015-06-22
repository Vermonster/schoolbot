# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
task(:default).clear

if Rails.env.test? || Rails.env.development?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)
  task default: :rubocop

  require 'scss_lint/rake_task'
  SCSSLint::RakeTask.new(:scss_lint)
  task default: :scss_lint

  task default: :spec

  desc 'Run the Ember app tests'
  task 'ember:test' do
    ember = Rails.root.join('client', 'node_modules', '.bin', 'ember')
    if File.exist? ember
      sh "cd #{Rails.root.join('client')} && #{ember} test --reporter dot"
    else
      fail "Ember binary missing: #{ember}"
    end
  end
  task default: 'ember:test'
end

if defined? RSpec
  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end
end

task default: "bundler:audit"
