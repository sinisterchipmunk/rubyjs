require_dependency 'test/unit/assertions'

class RubyJS::Translator::Adapter
  include Test::Unit::Assertions
  include RubyJS::Testing::Assertions
  attr_reader :result

  def initialize(sexp, parent = nil)
    if sexp.kind_of?(String) && sexp.length != 0
      sexp = RubyParser.new.parse(sexp).to_a
    end
    @parent = parent
    @sexp = sexp
    @params = {}

    if @sexp.nil? || @sexp.empty?
      @result = ''
    else
      @keyword = @sexp.shift
      method_name = "#{self.class.short_name}_for_#{@keyword}"
      @result = self.send(method_name)
      raise ArgumentError, "Expected ##{method_name} to return a String" unless @result.is_a?(String)
    end
  end

  def method_missing(name, *args, &block)
    params.key?(name) ? params[name] : super
  rescue
    raise $!.class,
          $!.message+"\n in #{parent ? "#{parent.keyword.inspect} -> " : ''}#{keyword.inspect} (#{@sexp.inspect})",
          caller
  end

  class << self
    def short_name
      self.name.underscore.gsub(/\A.*\/([^\/]+)\z/, '\1')
    end
  end

  protected
  attr_reader :parent, :keyword
  attr_reader :params

  def variable_declarations
    @vars_in_scope ||= []
  end

  def exactly_one_symbol(obj = remainder)
    exactly_one(Symbol, obj)
  end

  def exactly_one_string(obj = remainder)
    exactly_one(String, obj)
  end

  def exactly_one(type, obj = remainder)
    if obj.kind_of? Array
      assert_length 1, obj
      obj = obj.shift
    end
    assert_kind_of(type, obj)
    obj
  end

  def symbol_or_subprocess(obj)
    case obj
      when Array then subprocess(obj)
      when Symbol then obj.to_s
      else flunk "Unexpected object type: #{obj.class} (#{obj.inspect})"
    end
  end

  def remainder(sexp = @sexp)
    r = []
    r << (block_given? ? yield(sexp.shift) : sexp.shift) until sexp.empty?
    r
  end

  def subprocess(sexp)
    self.class.new(sexp, self).result
  end

  def pull(*keys)
    params.clear
    keys.flatten.each { |key| params[key] = @sexp.shift }
    params
  end

  def root(keyword = nil)
    p = self
    p = p.parent while p.parent && p.keyword != keyword
    p
  end

  def scope
    root(:block)
  end

  def class_name
    return root(:class).instance_variable_get("@class_name")
  end

  def superclass_name
    return root(:class).instance_variable_get("@superclass_name")
  end
end
