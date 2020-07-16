require_relative 'automated_init'

context "Apply Event" do
  fixture = Projection.build(
    Controls::Projection::Example,
    Controls::Entity.example,
    Controls::Event.example
  )

  fixture.()
end
