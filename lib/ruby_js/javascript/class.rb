class RubyJS::Javascript::Class
  include RubyJS::Javascript::Helpers
  
  attr_accessor :klass, :superklass
  attr_reader :methods_hash
  alias_method :name, :klass

  def initialize(klass, superklass = nil)
    @klass = javascript_class_name(klass)
    @superklass = superklass ? javascript_class_name(superklass) : nil
    @methods_hash = HashWithIndifferentAccess.new
  end

  def to_s(ignored = nil)
    if @superklass
      "var #{@klass} = Class.create(#{@superklass}, #{methods_hash.to_json});"
    else
      "var #{@klass} = Class.create(#{methods_hash.to_json});"
    end
  end

  alias to_javascript to_s

  def define_method(name, *args, &block)
    methods_hash[name] = if @superklass
      RubyJS::Javascript::Function.new(*args, &block)
    else
      options = args.extract_options!
      RubyJS::Javascript::Function.new(*(args + [options.merge(:super => false)]), &block)
    end
  end

  private
  def javascript_class_name(klass)
    case klass
      when Class then klass.name.sub(/^RubyJS\:\:Javascript\:\:Classes\:\:/, '')
      when RubyJS::Javascript::Class then klass.name
      else klass.to_s
    end
  end
end
