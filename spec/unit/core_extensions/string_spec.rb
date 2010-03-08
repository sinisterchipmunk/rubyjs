require 'spec_helper'

describe String do
  context "#parenthesize" do
    it "parenthesizes with one character" do
      'text'.parenthesize(':').should == ":text:"
    end

    it "parenthesizes with two characters" do
      'text'.parenthesize('[]').should == "[text]"
    end

    it "parenthesizes with defaults" do
      "text".parenthesize.should == "(text)"
    end
  end

  context "#depunctuate" do
    it "does not include question marks" do
      "kind_of?".depunctuate.should == "is_kind_of"
    end

    it "does not include exclamation points" do
      "save!".depunctuate.should == "force_save"
    end

    it "returns itself if no punctuation is found" do
      "save".depunctuate.should == "save"
    end
  end
end
