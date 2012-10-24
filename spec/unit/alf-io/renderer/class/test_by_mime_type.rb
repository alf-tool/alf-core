require 'spec_helper'
module Alf
  describe Renderer, ".by_mime_type" do

    context 'when mime type is unrecognized' do
      subject{
        Renderer.by_mime_type("no/suchone", [{id: "csv", name: "CSV"}])
      }

      it 'should raise an error' do
        lambda{
          subject
        }.should raise_error(UnsupportedMimeTypeError, /No renderer for `no\/suchone`/)
      end
    end

    context 'when such mime type is registered' do
      subject{
        Renderer.by_mime_type("text/csv", [{id: "csv", name: "CSV"}], col_sep: ";")
      }

      it{ should be_a(Renderer::CSV) }

      it 'should be wired correctly' do
        subject.execute("").should eq("id;name\ncsv;CSV\n")
      end
    end

  end
end
