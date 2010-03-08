%w(object string array hash).each do |fi|
  require File.join(RubyJS.path, 'core_extensions', fi)
end
