class Array
  def deep_dup
    self.collect do |ele|
      ele.respond_to?(:deep_dup) ? ele.deep_dup : ele.dup?
    end
  end
end
