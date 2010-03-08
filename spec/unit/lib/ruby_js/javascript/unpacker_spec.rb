require "spec_helper"

describe RubyJS::Javascript::Unpacker do
  it "formats complex code fragments" do
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

    RubyJS::Javascript::Unpacker.new(code).to_s.should == expected.strip.gsub(/  /, "\t")
  end
end