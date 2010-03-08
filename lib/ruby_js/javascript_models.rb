module RubyJS::JavascriptModels
  def self.included(base)
    base.send(:include, RubyJS::Javascript::Helpers)
  end

  def javascript_model(model_or_name_or_record)
    javascript_tag(RubyJS::JavascriptModel.new(model_or_name_or_record));
  end
end
