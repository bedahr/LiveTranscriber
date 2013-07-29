require 'ostruct'
require 'shellwords'

class String
  def shell_safe
    Shellwords.shellescape(self)
  end
end

class MatchData
  def to_hash
    Hash[ names.zip( captures ) ]
  end
end

class OpenStruct
  def all_attributes
    @table
  end
end

class Exception
  def exception_type
    self.class.to_s ? self.class.to_s.split("::").last : 'None'
  end

  def to_json
    "{\"error\":#{ActiveSupport::JSON.encode(self.message.gsub(/\r/, ' ').gsub(/\n/, ' ').squeeze(' '))}, \"type\":\"#{self.exception_type}\"}"
  end
end
