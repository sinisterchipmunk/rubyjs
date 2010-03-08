require 'spec_helper'

describe RubyJS::Translator::Adapter do
  it "has a short name" do
    RubyJS::Translator::Adapter.short_name.should == 'adapter'
  end

  it "#symbol_or_subprocess flunks when obj is neither symbol nor array" do
    proc { RubyJS::Translator::Adapter.new(nil).send(:symbol_or_subprocess, nil) }.
            should raise_error(Test::Unit::AssertionFailedError)
  end
end
