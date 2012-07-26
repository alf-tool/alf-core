require 'spec_helper'
module Alf
  module Operator::Relational
    describe Join, 'keys' do

      let(:op){ 
        a_lispy.join(left, right)
      }
      subject{ op.keys }

      context 'on same & unique keys' do
        let(:left){
          an_operand.with_heading(:id => Integer, :name => String).with_keys([ :id ])
        }
        let(:right){
          an_operand.with_heading(:id => Integer, :status => Integer).with_keys([ :id ])
        }
        let(:expected){
          Keys[ [ :id ] ]
        }

        it { should eq(expected) }
      end

      context 'on same but non unique keys' do
        let(:left){
          an_operand.with_heading(:id => Integer, :name => String).with_keys([ :id ], [ :name ])
        }
        let(:right){
          an_operand.with_heading(:id => Integer, :status => Integer).with_keys([ :id ], [ :status ])
        }
        let(:expected){
          Keys[ [ :id ], [ :name ], [ :status ] ]
        }

        it {
          pending "join key inference could be smarter" do
            should eq(expected)
          end
        }
      end

      context 'on a typical foreign key' do
        let(:left){
          an_operand.with_heading(:pid => Integer, :name => String).with_keys([ :pid ], [ :name ])
        }
        let(:right){
          an_operand.with_heading(:pk => Integer, :pid => Integer).with_keys([ :pk ])
        }
        let(:expected){
          Keys[ [ :pid, :pk ], [ :name, :pk ] ]
        }

        it { should eq(expected) }
      end

    end
  end
end
