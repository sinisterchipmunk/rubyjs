require 'test_helper'

class RubyJS::JavascriptModelTest < ActiveSupport::TestCase
  def setup
    @jsm = RubyJS::JavascriptModel.new("User")
  end

  test "produces a User class" do
    assert @jsm.to_s =~ /\Avar User = Class\.create\(ModelWrapper, \{/, @jsm.to_s
  end

  test "produces an :initialize method" do
    assert @jsm.methods_hash.include?(:initialize)
  end
end
