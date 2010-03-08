require 'test_helper'

class RubyJS::UnpackerTest < ActiveSupport::TestCase
  test "formats complex code fragments" do
    code = 'function test(a) { if (!a) { a = 5; }; Ajax.Request("/where", {complete:function(request) { alert(a); }}); }'
    expected = <<-end_code
function test(a) {
  if (!a) {
    a = 5;
  };
  Ajax.Request("/where",
    {
      complete:function(request) {
        alert(a);
      }
    });
}
    end_code
    assert_equal expected.strip.gsub(/  /, "\t"), RubyJS::Javascript::Unpacker.new(code).to_s
  end
end
