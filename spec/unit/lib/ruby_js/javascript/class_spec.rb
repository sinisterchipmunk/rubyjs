require 'spec_helper'

describe RubyJS::Javascript::Class do
  context "with a superclass" do
    before(:each) { @klass = RubyJS::Javascript::Class.new("MyClass", "Superclass") }

    it "should generate a js class" do
      @klass.to_javascript.should == 'var MyClass = Class.create(Superclass, {});'
    end
  end

  context "without a superclass" do
    before(:each) { @klass = RubyJS::Javascript::Class.new("MyClass") }

    it "should generate a js class" do
      @klass.to_javascript.should == 'var MyClass = Class.create({});'
    end
  end
end
