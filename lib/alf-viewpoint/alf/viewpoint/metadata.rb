module Alf
  module Viewpoint
    class Metadata

      def initialize(expectations = [], dependencies = {}, members = [])
        @expectations = expectations
        @dependencies = dependencies
        @members      = members
        yield(self) if block_given?
      end
      attr_reader :expectations, :dependencies, :members

      def expects(viewpoints)
        @expectations |= viewpoints
        self
      end

      def depends(pairs)
        @dependencies.merge!(pairs) do |k,v1,v2|
          v1 == v2 ? v1 : raise("Composition conflict on `#{k}`: #{v1.inspect} vs. #{v2.inspect}")
        end
        self
      end

      def add_members(members)
        @members |= members
        self
      end

      def all_members
        expand.members
      end

      def expand
        Metadata.new do |m|
          expectations.map{|e| e.metadata.expand }.each do |m2|
            m.expects(m2.expectations)
            m.depends(m2.dependencies)
            m.add_members(m2.members)
          end
          m.expects(expectations)
          m.depends(dependencies)
          m.add_members(members)
        end
      end

      def dup
        Metadata.new(expectations.dup, dependencies.dup, members.dup)
      end

      def to_module(context = {}, &bl)
        expanded = expand
        Module.new{
          include Alf::Viewpoint
          define_method(:contextual_params) do
            context
          end
          expanded.expectations.each do |exp|
            include(exp)
          end
          expanded.dependencies.each_pair do |as, vps|
            provider = Metadata.new(vps).to_module(context)
            define_method(as) do
              Lang::Lispy.new([provider], connection)
            end
          end
          instance_exec(&bl) if bl
        }
      end

    end # class Metadata
  end # module Viewpoint
end # module Alf
