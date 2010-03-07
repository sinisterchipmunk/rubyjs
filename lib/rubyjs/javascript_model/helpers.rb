require_dependency "action_view/helpers/javascript_helper"

module JavascriptModel::Helpers
  include ActionView::Helpers::JavaScriptHelper
  
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
