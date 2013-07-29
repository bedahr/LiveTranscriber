class Callbackable

  attr_accessor :callbacks

  def initialize
    @callbacks = {}
  end

  # Invokes a callback (if defined)
  def invoke(name, *args)
    callbacks[name.to_sym].call(*args) if callbacks[name.to_sym]
  end

  # Invokess a callback, raises if not defined
  def invoke!(name, *args)
    callbacks[name.to_sym] || raise("Callback not defined: #{name}")
    callbacks[name.to_sym].call(*args)
  end

  # Defines a callback method
  def method_missing(name, &block)
    callbacks[name] && raise("Callback already defined: #{name}")
    callbacks[name] = block
    self
  end

end
