require 'spec_helper'

describe RubyJS::JavascriptModels do
  before(:each) { @view = ActionView::Base.new }

  it "makes methods available to ActionView::Base" do
    @view.should respond_to(:javascript_model)
  end

  it "produces a js tag" do
    @view.javascript_model("User").should match(/\A<script.*<\/script>\z/m)
  end

  it "produces a js class" do
    @view.javascript_model("User").should match(/var User = Class\.create/)
  end
end
