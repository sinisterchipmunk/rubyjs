class RubyJS::JavascriptModel
  include RubyJS::Javascript::Helpers
  attr_reader :js_class
  delegate :methods_hash, :to => :js_class

  def initialize(model_or_name_or_record)
    @name = model_or_name_or_record
    @js_class = RubyJS::Javascript::Class.new(@name, ModelWrapper)
    add_methods
  end

  def to_s
    @js_class.to_s
  end

  private
  def add_methods
    @js_class.define_method :initialize do
    
    end
  end
end
