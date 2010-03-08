require 'spec_helper'

describe RubyJS::Javascript::Function do
  context "with no args" do
    before(:each) { @func = RubyJS::Javascript::Function.new }

    it "should generate an empty, anonymous JS function" do
      @func.to_javascript.should == 'function() {  }'
    end
  end

  context "with 1 arg" do
    before(:each) { @func = RubyJS::Javascript::Function.new("alert") }
    it "should generate an empty, named JS function" do
      @func.to_javascript.should == 'function alert() {  }'
    end
  end

  context "with 1 arg and :anonymous => true" do
    before(:each) { @func = RubyJS::Javascript::Function.new("message", :anonymous => true) }
    it "should generate an empty, anonymous JS function taking 1 arg" do
      @func.to_javascript.should == 'function(message) {  }'
    end
  end

  context "with 1 arg and an empty block taking 2 args" do
    before(:each) { @func = RubyJS::Javascript::Function.new("message") { |key, value| } }
    it "should generate an empty, named JS function taking 2 args" do
      @func.to_javascript.should == 'function message(arg1, arg2) {  }'
    end
  end
end
