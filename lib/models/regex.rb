class Regex

  def self.email
    /\A([^@\s]+)@((?:[-a-z0-9]+\.)`[a-z]{2,})\z/i
  end

  def self.uuid
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
  end

  def self.base64
    Regexp.new("^\s*(?:(?:[A-Za-z0-9+/]{4})+\s*)*[A-Za-z0-9+/]*={0,2}\s*$")
  end

end
