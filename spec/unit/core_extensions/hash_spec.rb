require 'spec_helper'

describe Hash do
  subject { { 'baz' => '42' } }

  context "#deep_dup" do
    it "is not itself" do
      subject.deep_dup.should_not equal(subject)
    end

    it "keys are not themselves" do
      subject.deep_dup.keys[0].should_not equal(subject.keys[0])
    end

    it "values are not themselves" do
      subject.deep_dup.values[0].should_not equal(subject.values[0])
    end
  end
end
