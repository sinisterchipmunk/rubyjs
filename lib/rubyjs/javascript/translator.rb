class Javascript::Translator
  class_inheritable_array :load_paths
  read_inheritable_attribute(:load_paths) || write_inheritable_attribute(:load_paths,
    [File.join(Rails.root, "lib/javascript/classes")])

  def initialize(klass_or_filename)
    klass = klass_from_klass_or_filename(klass_or_filename)
    @sexp = self.class.lookup(klass)
  end

  def to_s
    translate
  end

  def translate
    @translation ||= Javascript::Translator::SexpProcessor.new(@sexp).to_javascript
  end

  private
  def klass_from_klass_or_filename(klass_or_filename)
    klass_or_filename.kind_of?(String) ?
            klass_or_filename.sub(/^(.*)\.rb$/, '\1').camelize.constantize :
            klass_or_filename
  end

  class << self
    public
    def load
      load! unless loaded?
    end

    def load!
      loaded.clear
      load_paths.each do |load_path|
        load_files(load_path, *Dir[File.join(load_path, "**/*.rb")])
      end
    end

    def load_files(load_path, *filenames)
      add_load_path load_path
      filenames.each do |fi|
        fi = File.join(load_path, fi) unless File.file?(fi)
        class_name = fi.sub(/^#{Regexp::escape load_path}(\/|)(.*)(\.rb)$/, '\2').camelize
        klass = class_name.constantize
        loaded[klass] = RubyParser.new.parse(File.read(fi), fi).to_a
      end
    end

    alias load_file load_files

    def lookup(klass)
      loaded[klass]
    end

    def loaded?
      !loaded.empty?
    end

    def loaded
      @loaded ||= {}
    end

    private
    def add_load_path(load_path)
      return if $LOAD_PATH.include?(load_path)
      $LOAD_PATH << load_path
      ActiveSupport::Dependencies.load_paths << load_path
    end
  end
end
