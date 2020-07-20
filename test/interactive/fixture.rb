require_relative 'interactive_init'

context "Fixture" do
  entity = EntityProjection::Fixture::Controls::Entity::New.example
  projection = EntityProjection::Fixture::Controls::Projection::Example.build(entity)
  event = EntityProjection::Fixture::Controls::Event.example

  fixture(
    EntityProjection::Fixture,
    projection,
    event
  ) do |fixture|

    fixture.assert_attributes_copied([
      { :example_id => :id },
      :amount
    ])

    fixture.assert_transformed_and_copied(:time) { |v| Time.parse(v) }
    fixture.assert_transformed_and_copied(:processed_time => :updated_time) { |v| Time.parse(v) }
  end
end
