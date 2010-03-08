require 'spec_helper'

describe RubyJS::JavascriptModel do
  before(:each) { @jsm = RubyJS::JavascriptModel.new("User") }

  it "produces a js class" do
    @jsm.to_s.should match(/\Avar User = Class\.create\(ModelWrapper, \{/)
  end

  it "produces an :initialize function" do
    @jsm.methods_hash.should include(:initialize)
  end
end
