Dir[File.join(RAILS_ROOT, 'lib/extensions/**/*.rb')].each do |fi|
  require fi
end
