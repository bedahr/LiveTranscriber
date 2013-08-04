# Extendable
#
# Module that allows deferred extending of not yet defined classes.
#
#   extends :FooBar, :SomeModule
#
# Then when class FooBar is defined, and if it includes Extendable,
# it will have SomeModule included.
#
# SomeModule is given as a Symbol (or String) to also defer loading of SomeModule.
# It can also be given just as a constant.
#
#   extends :FooBar, :SomeModule
#   extends :FooBar, "SomeModule"
#   extends :FooBar, SomeModule
#
# You can also extend using a block instead of a module, this block is then included
# as well as an anonymous Module.
#
#   extends :FooBar do
#     def foo
#       "foo"
#     end
#   end
#
# To make the class extend the module (instead of include) provide option extend: true
# in any of the above scenarios.
#
#   extends :FooBar, :SomeModule, extend: true
#   extends :FooBar, extend: true do
#     def foo
#
# Instead of include/extend you can also eval code/block against the class.
#
#   extends :FooBar, "belongs_to :user", eval: true
#   extends :FooBar, eval: true do
#     belongs_to :user
#   end
#
# eval: true is a shortcut to with: :instance_eval. You can change to :class_eval
# (or any other method to be called on the class with the value and/or block)
#
#   extends :FooBar, with: :class_eval do
#     def foo
#     end
#   end
#
# If any of the scenarios you can provide both value and block in which case both
# are used to include, extend or eval.
#
# For more example check the attached unit test.
# To run the test just run the file (similar like other single file libraries).
#
#   ruby extendable.rb

module Extendable

  def self.logger
    @logger ||= begin
      ActiveRecord::Base.logger
    rescue
      require 'logger'
      Logger.new(STDOUT)
    end
  end


  def self.all_extensions
    @all_extensions ||= {}
  end

  def self.extensions_for(klass)
    all_extensions[klass.to_s] ||= []
  end


  # collects extension for given klass
  def self.add_extension(klass, value=nil, options={}, &block)
    if value.is_a?(Hash)
      options = value
      value   = nil
    end

    options[:value] = value
    options[:block] = block
    options[:with]  = :instance_eval if options.delete(:eval)

    extensions_for(klass.to_s).push(options)
  end


  # actuall extending code
  def self.extend_base(base, extension)
    if extension[:with]
      base.send(extension[:with],  extension[:value]) if extension[:value]
      base.send(extension[:with], &extension[:block]) if extension[:block]
    else
      method = extension[:extend] ? :extend : :include

      if extension[:value]
        case extension[:value]
        when Module         then base.send(method, extension[:value])
        when String, Symbol then base.send(method, extension[:value].to_s.constantize)
        else raise "invalid extension"
        end
      end

      if extension[:block]
        base.send(method, Module.new(&extension[:block]))
      end
    end
  end


  # apply extensions saved for including klass
  def self.included(base)
    Extendable.extensions_for(base).each do |extension|
      extend_base(base, extension)
      logger.info("#{base} extended with #{extension}") if logger
    end
  end

end

module Kernel
  def extends(*args, &block)
    Extendable.add_extension(*args, &block)
  end
end



if __FILE__ == $0
require 'test/unit'


# simple constantize mock
String.class_eval do
  def constantize
    eval(self)
  end
end


# helper to test eval
module SampleHelperModule
  def belongs_to_foo(name)
    class_eval("def #{name}; #{name.inspect}; end")
  end
end


# examples of usage
module Test01; def test01; :test01; end; end
module Test02; def test02; :test02; end; end

extends :FooBar, Test01
extends :FooBar, :Test02
extends :FooBar do
  def test03; :test03; end
end


module Test04; def test04; :test04; end; end
module Test05; def test05; :test05; end; end

extends :FooBar, Test04,  extend: true
extends :FooBar, :Test05, extend:  true
extends :FooBar, extend: true do
  def test06; :test06; end
end


extends :FooBar, with: :class_eval do
  def test07; :test07; end
end

extends :FooBar, with: :instance_eval do
  def test08; :test08; end
end

extends :FooBar, "belongs_to_foo :test09", eval: true do
  def test10; :test10; end
end


# testing class
class FooBar
  extend  SampleHelperModule
  include Extendable
end


# actuall unit test ;p
class ExtendableTest < Test::Unit::TestCase
  def test_including
    assert_equal :test01, FooBar.new.test01
    assert_equal :test02, FooBar.new.test02
    assert_equal :test03, FooBar.new.test03
  end

  def test_extending
    assert_equal :test04, FooBar.test04
    assert_equal :test05, FooBar.test05
    assert_equal :test06, FooBar.test06
  end

  def test_evals
    assert_equal :test07, FooBar.new.test07
    assert_equal :test08, FooBar.test08

    assert_equal :test09, FooBar.new.test09
    assert_equal :test10, FooBar.test10
  end
end

end # __FILE__ == $0
