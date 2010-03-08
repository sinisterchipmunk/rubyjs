require 'test_helper'

class RubyJS::JavascriptModelsTest < ActiveSupport::TestCase
  def setup
    @view = ActionView::Base.new
  end

  test "methods available to ActionView::Base" do
    assert @view.respond_to?(:javascript_model)
  end

  test "produces a ruby_js tag" do
    assert @view.javascript_model("User") =~ /\A<script.*<\/script>\z/m
  end

  test "produces a ruby_js class" do
    assert @view.javascript_model("User") =~ /var User = Class.create/
  end
end

#puts ActionView::Base.new.javascript_model("User")
