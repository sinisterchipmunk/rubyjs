require 'spec_helper'

describe RubyJS::Translator::Adapter do
  it "has a short name" do
    RubyJS::Translator::Adapter.short_name.should == 'adapter'
  end
end
