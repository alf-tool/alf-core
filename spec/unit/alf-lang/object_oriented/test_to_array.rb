require 'spec_helper'
module Alf
  module Lang
    describe ObjectOriented, 'to_array' do
      include ObjectOriented.new(supplier_names_relation)

      let(:ordering){ Ordering.coerce([[:name, :desc]]) }

      context 'with a block' do
        it 'yields the block with a ToArray' do
          seen = nil
          to_array{|x| seen = x}
          seen.should be_a(Engine::ToArray)
        end

        it 'returns the block result' do
          to_array{|x| 12}.should eq(12)
        end

        it 'sets the ordering correctly' do
          to_array(:sort => ordering){|x|
            x.ordering.should eq(ordering)
          }
        end
      end

      context 'without a block' do
        it 'returns an array' do
          to_array.should be_a(Array)
        end

        it 'respect the specified ordering' do
          expected = supplier_names.sort.reverse
          got      = to_array(:sort => ordering).map{|t| t[:name]}
          got.should eq(expected)

          expected = supplier_names.sort
          got      = to_array(:sort => [:name]).map{|t| t[:name]}
          got.should eq(expected)
        end
      end

    end
  end # module Lang
end # module Alf