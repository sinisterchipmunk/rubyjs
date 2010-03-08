require 'test_helper'

class RubyJS::Javascript::HelpersTest < ActiveSupport::TestCase
  include RubyJS::Javascript::Helpers

  test "produces a valid call to a ruby_js method" do
    assert_equal 'alert("Hi, "+name+"!")', js_call(:alert, 'Hi, #{name}!')
  end

  test "produces valid string concatenation" do
    assert_equal '"Hi, "+name+"!"', js_concat('Hi, #{name}!')
  end
end
