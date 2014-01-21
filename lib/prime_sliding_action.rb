require 'motion-cocoapods'
require 'motion-prime'

unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Require.all(Dir.glob(File.expand_path('../prime_sliding_action/**/*.rb', __FILE__)))

Motion::Project::App.setup do |app|
  
end