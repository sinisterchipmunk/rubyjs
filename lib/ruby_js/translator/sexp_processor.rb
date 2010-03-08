require_dependency 'test/unit/assertions'

class RubyJS::Translator::SexpProcessor
  include Test::Unit::Assertions
  include RubyJS::Testing::Assertions
  
  def initialize(sexp, parent = nil)
    @parent = parent
    @sexp = sexp
    @params = {}
  end

  def to_javascript
    if @sexp.nil? || @sexp.empty?
      return ""
    else
      @keyword = @sexp.shift
      r = self.send("javascript_for_#{@keyword}")
      raise ArgumentError, "Expected #javascript_for_#{@keyword} to return a String" unless r.is_a?(String)
      r.gsub(/(\s\s)/m, ' ')
    end
  end

  def method_missing(name, *args, &block)
    params.key?(name) ? params[name] : super
  rescue
    raise $!.class,
          $!.message+"\n in #{parent ? "#{parent.keyword.inspect} -> " : ''}#{keyword.inspect} (#{@sexp.inspect})",
          caller
  end

  protected
  attr_reader :parent, :keyword

  def variable_declarations
    @vars_in_scope ||= []
  end

  private
  attr_reader :params

  def javascript_for_iter
    call, args, body = remainder
    body = javascript_function_body(body)

    args = subprocess(args)
    # unit test - TODO: make this do something for calling other class methods as well
    if call[2] == :test && call[3] && call[3][1]
      return subprocess(call) + ": function(#{args}) { "+body+" }"
    end

    # any other call
    # we substring call because subprocess(call) wrapped arguments in parentheses; we need to essentially add a function
    # to the list of arguments. Considering an alternative: add the function to call before subprocessing?
    subprocess(call)[0...-1] + ", function(#{args}) { "+body+" })"
  end

  def javascript_function_body(sexp = @sexp)
    if sexp
      if !sexp.first.kind_of?(Array)
        subprocess(sexp)
      else
        remainder(sexp) { |item| subprocess(item) }.join('; ') + ';'
      end
    else
      ''
    end
  end

  def javascript_for_ivar
    exactly_one_symbol.to_s
  end

  def javascript_for_iasgn
    javascript_for_assignment
  end

  def javascript_for_gasgn
    javascript_for_assignment
  end

  def javascript_for_str
    exactly_one_string.to_json
  end

  def javascript_for_gvar
    javascript_name_for exactly_one_symbol
  end

  def javascript_for_lvar
    javascript_name_for exactly_one_symbol
  end

  def javascript_for_lasgn
    scope.variable_declarations << javascript_name_for(@sexp.first)
    javascript_for_assignment
  end

  def javascript_for_masgn
    sexp = exactly_one(Array)
    assert_equal :array, sexp.shift
    sexp.collect do |element|
      assert_equal :lasgn, element.first
      assert_length 2, element
      javascript_name_for element.last
    end.join(", ")
  end

  # This method can be called under 2 conditions: An assignment, such as left = right; or, in a more misleading
  # condition, when defining arguments for a function, ie function(left) { }. Notice that right is not included
  # in argument declarations; that's how we can differentiate the two. The way the sexp is cosntructed, we won't
  # have right arguments even if multiple arguments are being declared:
  #
  #    [:masgn, [:array, [:lasgn, :f], [:lasgn, :b]]] => (a, b)
  def javascript_for_assignment
    pull(:left, :right)
    assert_not_nil left, "Expected a left operand"

    left = javascript_name_for(self.left)
    if (right = self.right).kind_of? Array
      right = subprocess(right)
    end
    right ? "#{left} = #{javascript_name_for right}" : left
  end
  
  def javascript_for_arglist
    remainder do |item|
      assert_kind_of Array, item
      subprocess(item)
    end.join(", ").parenthesize
  end

  def javascript_for_call
    pull(:target, :method_name,  :arglist)
    target = self.target ? subprocess(self.target) : nil
    method_name = exactly_one_symbol(self.method_name)
    arglist = self.arglist

    if method_name == :new && !target.nil?
      # class instantiation
      "new " + target
    elsif method_name == :test && parent && parent.keyword == :iter && arglist.length == 2
      assert_kind_of Array, arglist.last
      test_name = arglist.last[1].gsub(/ /, '_')
      arglist = []

      "test_#{test_name}"
    else
      (target.nil? ? "" : target+".") + javascript_name_for(method_name)
    end + subprocess(arglist)
  end

  def javascript_for_colon2 # namespacing
    left, right = remainder
    object_or_type(left) + "." + object_or_type(right)
  end

  def javascript_for_block
    # parent is :scope, parent parent is :class, :defn, etc
    r = if parent && parent.parent && parent.parent.keyword == :class
      remainder { |item| subprocess(item) }.join(', ')
    else
      javascript_function_body
    end

    # include variable declarations
    (variable_declarations.empty? ? "" : "var #{variable_declarations.uniq.join(", ")};") + r
  end

  def javascript_for_args
    (["$super"] + remainder).join(", ")
  end

  def javascript_for_defn
    pull(:method_name, :args, :body)
    "#{javascript_name_for(method_name).to_json}: function(#{subprocess(args)}) #{subprocess(body)}"
  end

  def javascript_for_scope
    inner = (remainder do |item|
          assert_kind_of Array, item
          subprocess(item)
    end).join
    
    "{ "+
        inner +
    " }"
  end

  def javascript_for_class
    pull(:klass, :superclass, :body)
    "var #{klass} = Class.create(#{superclass ? subprocess(superclass)+", " : ''}#{subprocess body});"
  end

  def javascript_for_const
    exactly_one_symbol.to_s
  end

  def javascript_for_true
    "true"
  end

  def javascript_for_false
    "false"
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

  def object_or_type(obj)
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
    self.class.new(sexp, self).to_javascript
  end

  def pull(*keys)
    params.clear
    keys.flatten.each { |key| params[key] = @sexp.shift }
    params
  end

  def javascript_name_for(rubyvarname)
    raise ArgumentError, "Expected Symbol or String; found #{rubyvarname.inspect}" unless rubyvarname.kind_of?(Symbol) ||
            rubyvarname.kind_of?(String)
    rubyvarname = rubyvarname.to_s

    case rubyvarname[0]
      when ?@ # instance or class variable
        case rubyvarname[1]
          when ?@ # class variable
            rubyvarname[2..-1].depunctuate
          else    # instance variable
            "this."+rubyvarname[1..-1].depunctuate
        end
      when ?$ # global variable
        "document."+rubyvarname[1..-1].depunctuate
      else    # local variable
        rubyvarname[0..-1].depunctuate
    end
  end

  def root
    p = self
    p = p.parent while p.parent
    p
  end

  def scope
    p = self
    p = p.parent while p.parent && p.keyword != :block
    p
  end
end
