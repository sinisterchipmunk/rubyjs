class RubyJS::Javascript::Function
  attr_reader :options, :args, :scope

  def initialize(*args, &block)
    generate_options_for(args)
    @scope = RubyJS::Javascript::Scope.new(self)
    @args = create_args(*args)
    process_body(*args, &block) if block_given?
  end

  def to_javascript
    function = "function"
    function.concat " #{options[:name]}" if options[:name]
    function.concat "(#{args.join(", ")}) #{@scope.to_javascript}"
    function
  end

  def to_json(*a); to_javascript; end

  private
  def create_args(*args)
    args = ["$super"] + args if !args.include?("$super") && options[:super]
    args.collect do |arg|
      arg
    end
  end

  def generate_options_for(args)
    options = args.extract_options!
    options[:super] = false if !options[:super]
    unless options[:anonymous]
      options[:name] ||= args.shift
    end
    @options = options.reverse_merge({
      :super => true,
      :anonymous => nil
    })
  end

  def process_body(*args, &block)
    raise ArgumentError, "Expected a block" unless block_given?

    # Ruby bug: arity -1 is the same as artiy 0. Since -1 correlatest to |*args|, which means no mandatory args,
    # that makes sense, even though it carries a different implication.
    arg_count = block.arity
    raise ArgumentError, "Negative arity not yet supported" if arg_count < -1

    for i in (self.args.length+1)..arg_count
      argname = "arg#{i}"
      self.args << argname
    end

    @scope.process(&block)
  end
end
