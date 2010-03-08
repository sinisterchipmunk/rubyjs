require 'spec_helper'

describe ModelWrapper do
  before :each do
    @json = { :person => { :first_name => "Colin", :last_name => "Mackenzie", :age => 24 } }
  end

  context "with a model" do
    before(:each) { @wrapper = ModelWrapper.new("person", @json) }

    it "includes first_name attribute" do
      @wrapper.first_name.should == "Colin"
    end
  end

  context "with a nested model" do
    before(:each) { @wrapper = ModelWrapper.new("person", @json[:person]) }

    it "includes first_name attribute" do
      @wrapper.first_name.should == "Colin"
    end
  end
end