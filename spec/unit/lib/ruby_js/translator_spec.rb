require 'spec_helper'

describe RubyJS::Translator do
  before(:all) { RubyJS::Translator.load! }

  it "produces an empty js class" do
    RubyJS::Translator.new(EmptyClass).to_s.should == 'var EmptyClass = Class.create({ });'
  end
end
