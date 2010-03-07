require 'test_helper'

class EmptyClassTest < ActiveSupport::TestCase
  def setup
    Javascript::Translator.load_file(File.join(RubyJS.test_path, "support/mock"), "empty_class.rb")
    Javascript::Translator.load_file(File.join(RubyJS.test_path, "unit/mock"), "empty_class_test.rb")
    @class_translator = Javascript::Translator(EmptyClass)
    @test_translator = Javascript::Translator(EmptyClassTest)
  end

  test "produces a Ruby class" do
    assert EmptyClass.kind_of?(Class)
  end

  test "produces a JS class" do
    File.open(fi = File.join(File.dirname(__FILE__), "../../output/empty_class.js"), "w") { |f, b| f.puts @class_translator.to_s }
    puts File.read(fi)
    puts
  end

  test "produces a JS unit test" do
    $DEBUG = true
    r = @test_translator.to_s
    File.open(fi = File.join(File.dirname(__FILE__), "../../output/empty_class_test.js"), "w") do |f, b|
      f.puts Javascript::Unpacker.new(r)
    end
    puts r
    puts
    $DEBUG = false
  end
end
