require 'spec_helper'

describe Array do
  subject { [ 1, 2, "abc", "def", ["foo", "bar"], { 'baz' => '42' } ] }

  context "#deep_dup" do
    it "is not itself" do
      subject.deep_dup.should_not equal(subject)
    end

    it "elements are not themselves" do
      subject.deep_dup.each_with_index do |ele, index|
        subject[index].should_not equal(ele) unless ele.dup?.equal?(ele)
      end
    end

    it "hashes' keys are not themselves" do
      hash = subject.deep_dup.last
      hash.keys[0].should_not equal(subject.last.keys[0])
    end

    it "hashes' values are not themselves" do
      hash = subject.deep_dup.last
      hash.values[0].should_not equal(subject.last.values[0])
    end
  end
end
