class Hash
  def deep_dup
    r = self.class.new
    self.each do |key, value|
      key = key.respond_to?(:deep_dup) ? key.deep_dup : key.dup?
      value = value.respond_to?(:deep_dup) ? value.deep_dup : value.dup?
      r[key] = value
    end
    r
  end
end
