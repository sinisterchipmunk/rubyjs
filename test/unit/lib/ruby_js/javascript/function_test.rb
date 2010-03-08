require 'test_helper'

class RubyJS::Javascript::FunctionTest < ActiveSupport::TestCase
  test "produces a valid function with no arguments" do
    function = RubyJS::Javascript::Function.new
    assert_equal "function($super) {  }", function.to_s
  end

  test "produces a function without $super if function name is given" do
    function = RubyJS::Javascript::Function.new(:name => "jello")
    assert_equal "function jello() {  }", function.to_s
  end

  test "produces a valid function with an argument and a body" do
    function = RubyJS::Javascript::Function.new(:name) { "alert('Hi, '+name+'!');" }
    assert_equal "function($super, name) { alert('Hi, '+name+'!'); }", function.to_s
  end

  test "produces a valid function with no arguments and no super" do
    function = RubyJS::Javascript::Function.new(:super => false)
    assert_equal "function() {  }", function.to_s
  end

  test "produces a valid function with a name" do
    function = RubyJS::Javascript::Function.new(:name => :jello)
    assert_equal "function jello() {  }", function.to_s
  end

  test "produces a valid function with a name and dynamic body" do
    function = RubyJS::Javascript::Function.new(:name, :name => :say_hello) do
      #alert("Hi, #{name}")
    end
    
    assert_equal 'function say_hello(name) {  }', function.to_s
  end

  #test "produces a valid call to a function" do
  #  assert_equal '', @function.call('#{first_name} #{last_name}')
  #end
end
