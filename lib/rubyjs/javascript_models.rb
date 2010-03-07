module JavascriptModels
  def javascript_model(model_or_name_or_record)
    javascript_tag(JavascriptModel.new(model_or_name_or_record));
  end
end
