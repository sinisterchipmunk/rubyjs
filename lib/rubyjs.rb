$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubyjs/dependencies'

module RubyJS
  VERSION = '0.0.1'
  
  def self.path
    File.expand_path(File.join(File.dirname(__FILE__), "rubyjs"))
  end

  def self.test_path
    File.expand_path(File.join(File.dirname(__FILE__), '../test'))
  end
end

require File.join(RubyJS.path, 'core_extensions/string')
$LOAD_PATH << RubyJS.path
ActiveSupport::Dependencies.load_paths << RubyJS.path
ActiveSupport::Dependencies.load_once_paths << RubyJS.path

Javascript::Translator.load_paths << File.expand_path(File.join(RubyJS.path, "../../javascript/classes"))
if defined?(Rails) && defined?(Rails.root)
  Javascript::Translator.load_paths << File.join(Rails.root, "lib/javascript/classes")
end

ActionView::Helpers::AssetTagHelper::register_javascript_include_default "javascript_models"
ActionView::Base.send(:include, JavascriptModels)
Javascript::Translator.load_file(File.join(RubyJS.path, "../../javascript/classes"), "model_wrapper.rb")
