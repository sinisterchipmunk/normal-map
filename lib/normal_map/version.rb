class NormalMap
  module Version
    MAJOR, MINOR, TINY = 0, 0, 1
    STRING = [MAJOR, MINOR, TINY].join('.')
  end

  VERSION = Version::STRING
end
