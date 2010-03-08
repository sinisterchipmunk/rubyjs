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
    string = string.inspect
    if string.kind_of?(String)
      string.gsub(/\\\#\{([^\}]+)\}/m) { |match| "\"+#{$~[1]}+\"" }
    else
      string
    end
  end
end
