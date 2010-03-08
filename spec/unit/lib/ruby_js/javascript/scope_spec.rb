require 'spec_helper'

describe RubyJS::Javascript::Scope do
  context "with no arguments" do
    subject { RubyJS::Javascript::Scope.new }

    it "should have a variable list" do
      subject.variables.should be_kind_of(Array)
    end

    it "should produce javascript" do
      subject.to_javascript.should == '{  }'
    end

    it "should respond_to :process" do
      subject.should respond_to(:process)
    end

    it "should produce javascript when given a block of ruby" do
      subject.process do
        alert 'test'
      end
      subject.to_javascript.should == '{ alert("test"); }'
    end
  end
end
