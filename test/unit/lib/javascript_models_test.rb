require 'test_helper'

class JavascriptModelsTest < ActiveSupport::TestCase
  def setup
    @view = ActionView::Base.new
  end

  test "methods available to ActionView::Base" do
    assert @view.respond_to?(:javascript_model)
  end

  test "produces a javascript tag" do
    assert @view.javascript_model("User") =~ /\A<script.*<\/script>\z/m
  end

  test "produces a javascript class" do
    assert @view.javascript_model("User") =~ /var User = Class.create/
  end
end

#puts ActionView::Base.new.javascript_model("User")
