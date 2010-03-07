require 'test_helper'

class ModelWrapperTest < ActiveSupport::TestCase
  def setup
  end

  test "produces a class" do
    assert ModelWrapper.kind_of?(Class)
  end
end
