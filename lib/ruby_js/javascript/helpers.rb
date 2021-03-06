module RubyJS::Javascript::Helpers
  def self.included(base)
    base.send(:include, ActionView::Helpers)
  end
  
  def js_call(name, *args)
    function = "#{name}("
    args.collect! { |arg| function.concat(js_concat(arg)) }
    function.concat ")"
    function
  end

  def js_concat(string)
    # 'hi, #{name}!' => '"hi, "+name+"!"'
    string.inspect.gsub(/\\\#\{([^\}]+)\}/m) { |match| "\"+#{$~[1]}+\"" }
  end

  def create_scope
    if self.kind_of?(RubyJS::Javascript::Scope)
      scope = RubyJS::Javascript::Scope.new(self)
    else
      scope = RubyJS::Javascript::Scope.new
    end
    
    yield scope if block_given?
    scope
  end
end
