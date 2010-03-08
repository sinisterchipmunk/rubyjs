# -*- ruby -*-
gem 'hoe', '>=2.0.0'
require 'hoe'

$:.unshift 'lib'

require 'spec/version'
require 'spec/rake/spectask'
require 'spec/ruby'

Hoe.spec 'rubyjs' do
  self.version = Spec::VERSION::STRING
  self.summary = Spec::VERSION::SUMMARY
  self.description = "Generates JavaScript classes from Ruby code; works fine on its own but is designed for Rails."
  self.developer('Colin MacKenzie IV', 'sinisterchipmunk@gmail.com')
  self.extra_deps << ["actionpack",">=2.3.5"] << ["activesupport",">=2.3.5"] << ["ruby_parser",">=2.0.4"]
  self.extra_dev_deps << ["cucumber",">=0.3"] << ["rspec",">=0.2.1"] << ["rcov",">=0.9.8"]
  self.rspec_options = ['--options', 'spec/spec.opts']
  #self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.post_install_message = ""
end

['audit','test','test_deps','default','post_blog'].each do |task|
  Rake.application.instance_variable_get('@tasks').delete(task)
end

task :post_blog do
  # no-op
end

task :cleanup_rcov_files do
  rm_rf 'coverage.data'
end


if RUBY_VERSION =~ /^1.8/
  task :default => [:cleanup_rcov_files, :features, :verify_rcov]
else
  task :default => [:spec, :features]
end

namespace :spec do

  desc "Run all specs with rcov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--options', 'spec/spec.opts']
    t.rcov = true
    t.rcov_dir = 'coverage'
    t.rcov_opts = ['--exclude', "features,kernel,load-diff-lcs\.rb,instance_exec\.rb,lib/spec.rb,lib/spec/runner.rb,^spec/*,bin/spec,examples,/gems,/Library/Ruby,\.autotest,#{ENV['GEM_HOME']}"]
    t.rcov_opts << '--sort coverage --text-summary --aggregate coverage.data'
  end

  desc "Run files listed in spec/spec_files.txt"
  Spec::Rake::SpecTask.new(:focus) do |t|
    if File.exists?('spec/spec_files.txt')
      t.spec_files = File.readlines('spec/spec_files.txt').collect{|f| f.chomp}
    end
  end
end

begin
  require 'cucumber/rake/task'
  desc "Run Cucumber features"
  if RUBY_VERSION =~ /^1.8/
    Cucumber::Rake::Task.new :features do |t|
      t.rcov = true
      t.rcov_opts = ['--exclude', "features,kernel,load-diff-lcs\.rb,instance_exec\.rb,lib/spec.rb,lib/spec/runner.rb,^spec/*,bin/spec,examples,/gems,/Library/Ruby,\.autotest,#{ENV['GEM_HOME']}"]
      t.rcov_opts << '--no-html --aggregate coverage.data'
      t.cucumber_opts = %w{--format progress}
    end
  else
    task :features do
      sh 'cucumber --profile no_heckle'
    end
  end
rescue LoadError
  puts "You need cucumber installed to run cucumber tasks"
end

desc "Run failing examples (see failure output)"
Spec::Rake::SpecTask.new('failing_examples') do |t|
  t.spec_files = FileList['failing_examples/**/*_spec.rb']
  t.spec_opts = ['--options', 'spec/spec.opts']
end

def egrep(pattern)
  Dir['**/*.rb'].each do |fn|
    count = 0
    open(fn) do |f|
      while line = f.gets
        count += 1
        if line =~ pattern
          puts "#{fn}:#{count}:#{line}"
        end
      end
    end
  end
end

desc "Look for TODO and FIXME tags in the code"
task :todo do
  egrep /(FIXME|TODO|TBD)/
end

desc "verify_committed, verify_rcov, post_news, release"
task :complete_release => [:verify_committed, :verify_rcov, :post_news, :release]

desc "Verifies that there is no uncommitted code"
task :verify_committed do
  IO.popen('git status') do |io|
    io.each_line do |line|
      raise "\n!!! Do a git commit first !!!\n\n" if line =~ /^#\s*modified:/
    end
  end
end

namespace :update do
  desc "update the manifest"
  task :manifest do
    system %q[touch Manifest.txt; rake check_manifest | grep -v "(in " | patch]
  end
end

task :clobber => :clobber_tmp

task :clobber_tmp do
  cmd = %q[rm -r tmp]
  puts cmd
  system cmd if test ?d, 'tmp'
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :test do
  %w(unit).each do |target|
    Rcov::RcovTask.new(target) do |t|
      t.libs << 'lib'
      t.libs << "test"
      t.test_files = FileList["test/#{target}/**/*_test.rb"]
      t.output_dir = "test/coverage/#{target}"
      t.verbose = true
      t.rcov_opts << '--aggregate coverage.data'
    end
  end
end
=begin

require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'ruby_js' do
  self.developer 'FIXME full name', 'FIXME email'
  self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  self.rubyforge_name       = self.name # TODO this is default value
  self.
  # self.extra_deps         = [['activesupport','>= 2.0.2']]

end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end


require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

require(File.join(File.dirname(__FILE__), 'test/config', 'boot'))
require 'rake/testtask'
require 'tasks/rails'
=end
