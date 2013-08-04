class ActiveRecordChain

  ## ActiveRecordChain allows you to stack multiple finders over each other, and later retrieve them
  ##
  ## Example:
  #  @chain = ActiveRecordChain(List)
  #  @chain.where(:foo => 'bar')
  #  @chain.is_csv
  #  @chain.is_empty
  #
  #  @chain.finder  will be the ActiveRecord finder
  #  @chain.command will return 'List.where(:foo => 'bar').is_csv.is_empty

  attr_accessor :klass, :command_chain, :finder

  def initialize(klass)
    @klass         = klass
    @command_chain = []
    @finder        = klass
  end

  def command
    [ klass.to_s, command_chain ].reject(&:blank?).join('.')
  end

  # Overloading select to avoid conflicts
  def select(*args, &block)
    method_missing(:select, *args, &block)
  end

  def method_missing(name, *args, &block)
    if args.any?
      @command_chain << "#{name}(#{args.collect { |k| k.inspect }.join(', ')})"
    else
      @command_chain << name
    end

    @finder = @finder.send(name, *args, &block)

    self
  end

end
