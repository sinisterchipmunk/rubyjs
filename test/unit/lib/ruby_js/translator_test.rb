require 'test_helper'

class RubyJS::TranslatorTest < ActiveSupport::TestCase
  def setup
    RubyJS::Translator.load!
  end

  test "produces an empty ruby_js class" do
    js = RubyJS::Translator.new(EmptyClass)
    assert_equal "var EmptyClass = Class.create({ });", js.to_s
  end
end
