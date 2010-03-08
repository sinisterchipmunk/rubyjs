class RubyJS::Translator::SexpProcessor
  def initialize(sexp)
    if sexp.kind_of?(String)
      sexp = RubyParser.new.parse(sexp).to_a
    end
    @sexp = sexp
  end

  class << self
    def attach_adapter(adapter)
      define_method "to_#{adapter.short_name}" do
        if @sexp.nil? || @sexp.empty?
          return ""
        else
          adapter.new(@sexp.deep_dup).result.gsub(/(\s\s)/m, ' ')
        end
      end
    end
  end
end
