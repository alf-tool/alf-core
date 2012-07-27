class OperandHelper

  def initialize
    @attributes = {}
  end

  def with_heading(h)
    dup.set!(:heading => Alf::Heading.coerce(h))
  end

  def with_keys(*keys)
    dup.set!(:keys => Alf::Keys.coerce(keys))
  end

  def method_missing(name, *args, &bl)
    if args.empty? and bl.nil?
      @attributes.fetch(name) rescue super
    else
      super
    end
  end

  def to_lispy
    "an_operand"
  end

protected

  def set!(h)
    @attributes.merge!(h)
    self
  end

end
