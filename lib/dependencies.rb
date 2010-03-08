require 'rubygems'
require 'ruby_parser'
require 'active_support'

unless defined?(ActionView)
  require 'action_controller'
  require 'action_view'
end

$LOAD_PATH << $rubyjs_dir
ActiveSupport::Dependencies.load_paths << $rubyjs_dir
ActiveSupport::Dependencies.load_once_paths << $rubyjs_dir
