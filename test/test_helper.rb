require File.dirname(__FILE__) + '/../lib/ruby_js'
require 'test/unit'
require 'active_support/test_case'

RubyJS::Translator.load_paths << File.join(File.dirname(__FILE__), "mock")
RubyJS::Translator.load
