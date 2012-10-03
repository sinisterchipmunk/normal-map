module Fixtures
  def fixture_path relative
    File.expand_path File.join('../fixtures', relative),
                     File.dirname(__FILE__)
  end

  def fixture relative
    File.open fixture_path(relative), 'rb' do |f|
      f.read
    end
  end
end
