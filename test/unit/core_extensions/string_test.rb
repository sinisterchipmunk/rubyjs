require 'test_helper'

class StringTest < ActiveSupport::TestCase
  test "parenthesizes with one character" do
    assert_equal ":text:", 'text'.parenthesize(':')
  end

  test "parenthesizes with two characters" do
    assert_equal "[text]", 'text'.parenthesize('[]')
  end

  test "parenthesizes with defaults" do
    assert_equal "(text)", "text".parenthesize
  end

  test "depunctuate does not include question marks" do
    assert_equal "is_kind_of", "kind_of?".depunctuate
  end

  test "depunctuate does not include exclamation points" do
    assert_equal "force_save", "save!".depunctuate
  end

end
