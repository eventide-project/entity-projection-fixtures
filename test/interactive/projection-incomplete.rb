require_relative 'interactive_init'

context "Projection" do
  entity = EntityProjection::Fixture::Controls::Entity::New.example
  control_entity = EntityProjection::Fixture::Controls::Entity::New.example

  event = EntityProjection::Fixture::Controls::Event.example

  projection = EntityProjection::Fixture::Controls::Projection::Example.build(entity)

  detail "Event: #{event.pretty_inspect}"
  detail "Control Entity: #{control_entity.pretty_inspect}"

  fixture(
    EntityProjection::Fixture,
    projection,
    event
  )
end
