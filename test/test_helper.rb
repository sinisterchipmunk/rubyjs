#require 'stringio'
#require 'test/unit'

# Simulate a Rails environment, since that is the target environ.
# Note we silence the warnings here, because I can't do anything about them.
_v = $VERBOSE
$VERBOSE = false
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/config/environment")
require 'test_help'
$VERBOSE = _v

# Set up test environment
require File.dirname(__FILE__) + '/../lib/rubyjs'
Javascript::Translator.load_paths << File.join(File.dirname(__FILE__), "support/mock")
