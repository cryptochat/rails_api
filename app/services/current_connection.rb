require 'singleton'

class CurrentConnection
  include Singleton
  attr_accessor :session_key, :params
end
