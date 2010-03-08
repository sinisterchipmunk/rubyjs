$rubyjs_dir = File.expand_path(File.dirname(__FILE__))
require 'dependencies'
require 'core_extensions'

class RubyJS
  VERSION = '0.0.1' unless defined?(VERSION)

  class << self
    define_method :Translator do |klass|
      RubyJS::Translator.new(klass)
    end

    def inherited(base)
      caller.first =~ /(.*):([0-9]+)/
      file, line = $~[1], $~[2]
      path, filename = File.dirname(file), File.basename(file)

      eval "def base.source_path; #{path.inspect}; end"
      eval "def base.source_filename; #{filename.inspect}; end"
      RubyJS::Translator.load_file(base.source_path, File.basename(base.source_filename))
    end

    def translator
      RubyJS::Translator(self.class)
    end

    def to_javascript
      translator.to_javascript
    end

    def path
      $rubyjs_dir
    end

    def test_path
      File.expand_path(File.join($rubyjs_dir, '../test'))
    end
  end
end

RubyJS::Translator.load_paths << File.expand_path(File.join(RubyJS.path, "../../ruby_js/classes"))
if defined?(Rails) && defined?(Rails.root)
  RubyJS::Translator.load_paths << File.join(Rails.root, "lib/ruby_js/classes")
end

ActionView::Helpers::AssetTagHelper::register_javascript_include_default "javascript_models"
ActionView::Base.send(:include, RubyJS::JavascriptModels)
#Javascript::Translator.load_file(File.join(RubyJS.path, "../../ruby_js/classes"), "model_wrapper.rb")
