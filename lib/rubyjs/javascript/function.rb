class Javascript::Function
  attr_reader :options, :args, :body
  
  def initialize(*args, &block)
    generate_options_for(args)
    @body = block_given? ? process_body(*args, &block) : ""
    @args = create_args(*args)
  end

  def to_s(ignored = nil)
    function = "function"
    function.concat " #{options[:name]}" if options[:name]
    function.concat "(#{args.join(", ")}) { #{body} }"
    function
  end

  alias to_json to_s

  private
  def create_args(*args)
    args = ["$super"] + args if !args.include?("$super") && options[:super]
    args.collect do |arg|
      arg
    end
  end

  def generate_options_for(args)
    options = args.extract_options!
    options[:super] = false if options[:name] && !options[:super]
    @options = options.reverse_merge({
      :super => true,
      :name => nil
    })
  end

  def process_body(*args, &block)
    # Ruby bug: arity -1 is the same as artiy 0. Since -1 correlatest to |*args|, which means no mandatory args,
    # that makes sense, even though it carries a different implication.
    #arg_count = block.arity
    #raise ArgumentError, "Negative arity not yet supported" if arg_count < -1

    block_given? ? yield : ""
  end
end
