class Javascript::Class
  include JavascriptModel::Helpers
  
  attr_accessor :klass, :superklass
  attr_reader :methods_hash
  alias_method :name, :klass

  def initialize(klass, superklass = nil)
    @klass = javascript_class_name(klass)
    @superklass = javascript_class_name(superklass)
    @methods_hash = HashWithIndifferentAccess.new
  end

  def to_s(ignored = nil)
    if @superklass
      "var #{@klass} = Class.create(#{@superklass}, #{methods_hash.to_json});"
    else
      "var #{@klass} = Class.create(#{methods_hash.to_json});"
    end
  end

  alias to_json to_s

  def define_method(name, *args, &block)
    methods_hash[name] = if @superklass
      Javascript::Function.new(*args, &block)
    else
      options = args.extract_options!
      Javascript::Function.new(*(args + [options.merge(:super => false)]), &block)
    end
  end

  private
  def javascript_class_name(klass)
    case klass
      when Class then klass.name.sub(/^Javascript\:\:Classes\:\:/, '')
      when Javascript::Class then klass.name
      else klass.to_s
    end
  end
end
