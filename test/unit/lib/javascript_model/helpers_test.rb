require 'test_helper'

class JavascriptModel::HelpersTest < ActiveSupport::TestCase
  include JavascriptModel::Helpers

  test "produces a valid call to a javascript method" do
    assert_equal 'alert("Hi, "+name+"!")', js_call(:alert, 'Hi, #{name}!')
  end

  test "produces valid string concatenation" do
    assert_equal '"Hi, "+name+"!"', js_concat('Hi, #{name}!')
  end
end
