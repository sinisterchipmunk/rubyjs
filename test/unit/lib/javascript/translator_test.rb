require 'test_helper'

class Javascript::TranslatorTest < ActiveSupport::TestCase
  def setup
    Javascript::Translator.load!
  end

  test "produces an empty javascript class" do
    js = Javascript::Translator.new(EmptyClass)
    assert_equal "var EmptyClass = Class.create({ });", js.to_s
  end
end
