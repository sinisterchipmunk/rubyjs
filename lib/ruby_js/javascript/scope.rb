class RubyJS::Javascript::Scope
  include RubyJS::Javascript::Helpers
  attr_reader :variables
  
  def initialize(parent = nil)
    @parent = parent
    @variables = []
    @instructions = []
  end

  def to_javascript
    r = javascript_for_variables
    unless (r = javascript_for_variables).blank?
      r.concat ' '
    end
    r.concat javascript_for_instructions

    "{ #{r} }"
  end

  def process(&block)
    instance_eval &block
  end

  # TODO: Re-evaluate method_missing here. Should we be explicitly defining JS methods instead?
  def method_missing(name, *args, &block)
    if block_given?
      raise "not implemented: create an anonymous function to contain block arguments"
    end
    instruction = "#{name}(#{args.collect { |i| i.inspect }.join(', ')});"
    @instructions << instruction
  end

  private
  def javascript_for_variables
    @variables.empty? ? "" : "var #{@variables.join(', ')};"
  end

  def javascript_for_instructions
    @instructions.join(" ")
  end
end
