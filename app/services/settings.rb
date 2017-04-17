require 'singleton'

class Settings
  include Singleton
  attr_accessor :encryption_enable
end
