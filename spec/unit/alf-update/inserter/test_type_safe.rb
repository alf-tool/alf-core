require 'update_helper'
module Alf
  module Update
    describe Inserter, 'type_safe' do

      subject{ insert(expr, inserted); db_context.requests }

      context 'when not strict' do
        let(:expr){ type_safe(suppliers, {status: Integer, name: String}) }

        context 'when the inserted tuples are ok' do
          let(:inserted) { [ {status: 10, name: "Smith"} ] }

          it 'does not complain and passes the tuples through' do
            subject.should eq([ [:insert, :suppliers, inserted] ])
          end
        end

        context 'when the inserted tuples are projections' do
          let(:inserted) { [ {status: 10} ] }

          it 'does not complain and passes the tuples through' do
            subject.should eq([ [:insert, :suppliers, inserted] ])
          end
        end

        context 'when the inserted tuples are ko' do
          let(:inserted) { [ {status: '10'} ] }

          it 'complains with a TypeCheckError' do
            lambda{
              subject
            }.should raise_error(TypeCheckError)
          end
        end
      end

      context 'when strict' do
        let(:expr){ type_safe(suppliers, {status: Integer, name: String}, strict: true) }

        context 'when the inserted tuples are ok' do
          let(:inserted) { [ {status: 10, name: "Smith"} ] }

          it 'does not complain and passes the tuples through' do
            subject.should eq([ [:insert, :suppliers, inserted] ])
          end
        end

        context 'when the inserted tuples are projections' do
          let(:inserted) { [ {status: 10} ] }

          it 'complains with a TypeCheckError' do
            lambda{
              subject
            }.should raise_error(TypeCheckError)
          end
        end

        context 'when the inserted tuples are ko' do
          let(:inserted) { [ {status: '10'} ] }

          it 'complains with a TypeCheckError' do
            lambda{
              subject
            }.should raise_error(TypeCheckError)
          end
        end
      end

    end
  end
end
