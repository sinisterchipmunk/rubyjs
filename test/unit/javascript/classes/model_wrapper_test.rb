require 'test_helper'

class ModelWrapperTest < ActiveSupport::TestCase
  def setup
    @json = { :person => { :first_name => "Colin", :last_name => "Mackenzie", :age => 24 } }
  end

  test "includes first_name attribute" do
    ex = ModelWrapper.new("person", @json)
    assert_equal "Colin", ex.first_name
  end
end
