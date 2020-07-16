require_relative 'automated_init'

_context "Construction" do
  fixture = Projection.build(
    Controls::Projection::Example,
    Controls::Entity.example,
    Controls::Event.example
  )
end
