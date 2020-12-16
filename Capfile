# frozen_string_literal: true

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/puma'
require 'capistrano/rails'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'capistrano/scm/git'
require 'whenever/capistrano'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
