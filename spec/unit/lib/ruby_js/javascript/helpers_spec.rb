require 'spec_helper'

describe RubyJS::Javascript::Helpers do
  include RubyJS::Javascript::Helpers

  it "produces a valid js function call" do
    js_call(:alert, 'Hi, #{name}!').should == 'alert("Hi, "+name+"!")'
  end

  context "#js_concat" do
    context "with string argument" do
      it "produces valid string concatenation" do
        js_concat('Hi, #{name}!').should == '"Hi, "+name+"!"'
      end
    end
  end
end
