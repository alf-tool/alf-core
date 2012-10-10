shared_examples_for "a facade on database options" do

  it{ should respond_to(:schema_cache?)     }
  it{ should respond_to(:default_viewpoint) }

end