module Javascript
  class << self
    define_method :Translator do |klass|
      Javascript::Translator.new(klass)
    end
  end
end
