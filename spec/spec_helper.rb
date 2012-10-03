require 'normal_map'

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each do |f|
  require f
end

RSpec.configure do |conf|
  conf.include Fixtures
end
