module Javascript::Assertions
  def assert_length(len, obj, message="Expected to find #{len} elements, found #{obj.inspect}")
    assert_equal len, obj.length, message
  end

  def assert_not_empty(arr, message="Expected to be not empty")
    assert !arr.empty?, message
  end

  def assert_empty(arr, message="Expected to be empty")
    assert arr.empty?, message
  end

  def assert_not_blank(str, message="Expected to be not blank")
    assert !str.blank?, message
  end

  def assert_blank(str, message="Expected to be blank")
    assert str.blank?, message
  end
end