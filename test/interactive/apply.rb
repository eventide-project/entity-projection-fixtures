require_relative 'interactive_init'

context "Apply" do
  fixture(
    Projection,
    Controls::Projection::Example,
    Controls::Entity.example,
    Controls::Event.example
  )
end
