class ModelWrapper < RubyJS
  def initialize(name, attributes)
    if attributes.size == 1 && attributes.keys[0].to_s == name.to_s
      assign_attributes(attributes.values[0])
    else
      assign_attributes(attributes)
    end
  end

  def assign_attributes(attributes)
    attributes.each do |key, value|
      self.class.send(:define_method, key) do
        value
      end
    end
  end
end
