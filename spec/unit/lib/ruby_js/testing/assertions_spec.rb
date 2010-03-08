require 'spec_helper'
require 'test/unit/assertionfailederror'
require 'test/unit/assertions'

describe RubyJS::Testing::Assertions do
  include Test::Unit::Assertions
  include RubyJS::Testing::Assertions

  context "passing assertions" do
    it "asserts length" do
      proc { assert_length 1, [1] }.should_not raise_error
    end

    it "asserts not empty" do
      proc { assert_not_empty [1] }.should_not raise_error
    end

    it "asserts empty" do
      proc { assert_empty [] }.should_not raise_error
    end

    it "asserts not blank" do
      proc { assert_not_blank '1' }.should_not raise_error
    end

    it "asserts blank" do
      proc { assert_blank '' }.should_not raise_error
    end
  end

  context "failing assertions" do
    it "asserts length" do
      proc { assert_length 1, [1,1] }.should raise_error(Test::Unit::AssertionFailedError)
    end

    it "asserts not empty" do
      proc { assert_not_empty [] }.should raise_error(Test::Unit::AssertionFailedError)
    end

    it "asserts empty" do
      proc { assert_empty [1] }.should raise_error(Test::Unit::AssertionFailedError)
    end

    it "asserts not blank" do
      proc { assert_not_blank '' }.should raise_error(Test::Unit::AssertionFailedError)
    end

    it "asserts blank" do
      proc { assert_blank '1' }.should raise_error(Test::Unit::AssertionFailedError)
    end
  end
end
